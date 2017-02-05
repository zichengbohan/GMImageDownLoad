//
//  GMRequest.m
//  GMImageDownLoad
//
//  Created by xbm on 2017/2/3.
//  Copyright © 2017年 xbm. All rights reserved.
//

#import "GMRequest.h"

@interface GMRequest ()

@property (nonatomic, strong) NSMutableData *allData;
@property (nonatomic, copy) GraphicCodeBlock myBolck;

@end

@implementation GMRequest

- (void)postGraphValidateCodeCompeplet:(GraphicCodeBlock)transactionBlock {
    self.myBolck = transactionBlock;
    NSString *urlString = @"http://10.143.117.22:7080/myfang/apply/captcha/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
//    [request setValue:@"IOS#1.0.6" forHTTPHeaderField:@"User-Clerk"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];

    [dataTask resume];

    [session finishTasksAndInvalidate];

//    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (response && data) {
//            //DebugLog(@"garph code data:%@",data);
//            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//            if ([httpResponse.allHeaderFields objectForKey:@"imageCode"]) {
//                transactionBlock([httpResponse.allHeaderFields objectForKey:@"imageCode"], data);
//            }
//        }
//    }];
//    [sessionTask resume];
}



- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    
    /** a. 初始化allData属性(步骤1中设置的属性). */
    self.allData = [NSMutableData data];
    
    /** b. 让任务继续正常进行.(如果没有写这行代码, 将不会执行下面的代理方法.) */
    completionHandler(NSURLSessionResponseAllow);
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    /** 接收返回的数据. */
    [self.allData appendData:data];
    _myBolck(@"", data);

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    /** 处理数据. */
    NSError *er = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self.allData options:NSJSONReadingMutableContainers error:&er];
    NSLog(@"result: %@", result);
}

@end
