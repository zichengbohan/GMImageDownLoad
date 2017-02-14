//
//  ViewController.m
//  GMImageDownLoad
//
//  Created by xbm on 2017/2/3.
//  Copyright © 2017年 xbm. All rights reserved.
//

#import "ViewController.h"
#import "GMRequest.h"
#import "UIImageView+GMWebCache.h"
//#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIImageView *animationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.myImageView gm_setImageWithURL:[NSURL URLWithString:@"http://10.143.117.19:8080/fen-api/getVerifyImgCode/?image_uid=0E403478-00C5-4188-AAE9-CCF5350C993D"] param:nil];
    
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    NSMutableArray *arraym = [[NSMutableArray alloc] init];
    for (int i = 1; i < 9; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", i] ofType:@"png"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSDictionary *dic = @{@"url":url, @"param": @{@"key":[NSString stringWithFormat:@"%d", i]}};
        [arraym addObject:dic];
    }
//    NSURL *url1 = [NSURL URLWithString:@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg"];
//    NSURL *url2 = [NSURL URLWithString:@"http://pic2.cxtuku.com/00/02/31/b945758fd74d.jpg"];
    
//    NSURL *url = [NSURL URLWithString:@""];
//    NSArray *array = @[url1, url2];
    NSLog(@"imageUrls:%@", arraym);
    [self.animationView gm_setAnimationImagesWithURLsAndParams:arraym];
//    [GMRequest.new postGraphValidateCodeCompeplet:^(NSString *imageCode, NSData *data) {
////        self.imageCode = imageCode;
//        //DebugLog(@"data = %@",data);
//        if (data) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.myImageView.image = [UIImage imageWithData:data];
////                [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
//            });
//        }
//    }];
    
//    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg"]];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
