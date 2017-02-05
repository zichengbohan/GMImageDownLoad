//
//  GMRequest.h
//  GMImageDownLoad
//
//  Created by xbm on 2017/2/3.
//  Copyright © 2017年 xbm. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void (^GraphicCodeBlock)(NSString *imageCode, NSData *imageData);//获取图像验证码回调


@interface GMRequest : NSObject <NSURLSessionDelegate,  NSURLSessionDataDelegate>

- (void)postGraphValidateCodeCompeplet:(GraphicCodeBlock)transactionBlock;


@end
