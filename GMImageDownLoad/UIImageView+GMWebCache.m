//
//  UIImageView+GMWebCache.m
//  GMImageDownLoad
//
//  Created by xbm on 2017/2/4.
//  Copyright © 2017年 xbm. All rights reserved.
//

#import "UIImageView+GMWebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char imageURLKey;
static char TAG_ACTIVITY_INDICATOR;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;


@implementation UIImageView (GMWebCache)

- (void)gm_setImageWithURL:(NSURL *)url param:(NSDictionary *)param {
    [self gm_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil param:param];
}

- (void)gm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder param:(NSDictionary *)param {
    [self gm_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil param:param];
}

- (void)gm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(GMWebImageOptions)options param:(NSDictionary *)param {
    [self gm_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil param:param];
}

- (void)gm_setImageWithURL:(NSURL *)url completed:(GMWebImageCompletionBlock)completedBlock param:(NSDictionary *)param {
    [self gm_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock param:param];
}

- (void)gm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(GMWebImageCompletionBlock)completedBlock param:(NSDictionary *)param {
    [self gm_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock param:param];
}

- (void)gm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(GMWebImageOptions)options completed:(GMWebImageCompletionBlock)completedBlock param:(NSDictionary *)param {
    [self gm_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock param:param];
}

- (void)gm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(GMWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(GMWebImageCompletionBlock)completedBlock param:(NSDictionary *)param {
    [self gm_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {
        
        // check if activityView is enabled or not
        if ([self showActivityIndicatorView]) {
            [self addActivityIndicator];
        }
        
        __weak __typeof(self)wself = self;
        id <SDWebImageOperation> operation = [GMWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [wself removeActivityIndicator];
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        } param:param];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            [self removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)gm_setImageWithPreviousCachedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(GMWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(GMWebImageCompletionBlock)completedBlock param:(NSDictionary *)param {
    NSString *key = [[GMWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self gm_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock param:param];
}

- (NSURL *)gm_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)gm_setAnimationImagesWithURLsAndParams:(NSArray *)arrayOfURLsAndParams {
    [self gm_cancelCurrentAnimationImagesLoad];
    __weak __typeof(self)wself = self;
    
    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *logoImageURLAndParam in arrayOfURLsAndParams) {
        id <SDWebImageOperation> operation = [GMWebImageManager.sharedManager downloadImageWithURL:logoImageURLAndParam[@"url"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];
                    
                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        } param:logoImageURLAndParam[@"param"]];
        [operationsArray addObject:operation];
    }
    
    [self sd_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)gm_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)gm_cancelCurrentAnimationImagesLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}


#pragma mark -
- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)setShowActivityIndicatorView:(BOOL)show{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_SHOW, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)showActivityIndicatorView{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_SHOW) boolValue];
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)getIndicatorStyle{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_STYLE) intValue];
}

- (void)addActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self getIndicatorStyle]];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        dispatch_main_async_safe(^{
            [self addSubview:self.activityIndicator];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        });
    }
    
    dispatch_main_async_safe(^{
        [self.activityIndicator startAnimating];
    });
    
}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

@end
