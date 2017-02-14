//
//  UIImageView+GMWebCache.h
//  GMImageDownLoad
//
//  Created by xbm on 2017/2/4.
//  Copyright © 2017年 xbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "GMWebImageManager.h"

@interface UIImageView (GMWebCache)

- (NSURL *)gm_imageURL;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url The url for the image.
 */
- (void)gm_setImageWithURL:(NSURL *)url param:(NSDictionary *)param;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see sd_setImageWithURL:placeholderImage:options:
 */
- (void)gm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder param:(NSDictionary *)param;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options     The options to use when downloading the image. @see GMWebImageOptions for the possible values.
 */
- (void)gm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(GMWebImageOptions)options param:(NSDictionary *)param;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrieved from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)gm_setImageWithURL:(NSURL *)url completed:(GMWebImageCompletionBlock)completedBlock param:(NSDictionary *)param;

/**
 * Set the imageView `image` with an `url`, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrieved from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)gm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(GMWebImageCompletionBlock)completedBlock param:(NSDictionary *)param;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see GMWebImageOptions for the possible values.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrieved from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)gm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(GMWebImageOptions)options completed:(GMWebImageCompletionBlock)completedBlock param:(NSDictionary *)param;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see GMWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrieved from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)gm_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(GMWebImageOptions)options progress:(GMWebImageDownloaderProgressBlock)progressBlock completed:(GMWebImageCompletionBlock)completedBlock param:(NSDictionary *)param;

/**
 * Set the imageView `image` with an `url` and optionally a placeholder image.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see GMWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrieved from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)gm_setImageWithPreviousCachedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(GMWebImageOptions)options progress:(GMWebImageDownloaderProgressBlock)progressBlock completed:(GMWebImageCompletionBlock)completedBlock param:(NSDictionary *)param;

/**
 * Download an array of images and starts them in an animation loop
 *
 * @param arrayOfURLsAndParams An array of NSURL and Param
 */
- (void)gm_setAnimationImagesWithURLsAndParams:(NSArray *)arrayOfURLsAndParams;

/**
 * Cancel the current download
 */
- (void)gm_cancelCurrentImageLoad;

- (void)gm_cancelCurrentAnimationImagesLoad;

/**
 *  Show activity UIActivityIndicatorView
 */
- (void)setShowActivityIndicatorView:(BOOL)show;

/**
 *  set desired UIActivityIndicatorViewStyle
 *
 *  @param style The style of the UIActivityIndicatorView
 */
- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style;

@end
