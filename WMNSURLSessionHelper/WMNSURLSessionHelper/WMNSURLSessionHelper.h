//
//  WMNSURLSessionHelper.h
//  WMNSURLSessionHelper
//
//  Created by 软件工程系01 on 17/3/18.
//  Copyright © 2017年 软件工程系01. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompleBlock)(NSDictionary *dic,NSURLResponse *response,NSError *error);
typedef void (^SuccessBlock)(NSDictionary *data);
typedef void (^FilureBlock)(NSError *error);


@interface WMNSURLSessionHelper : NSObject<NSURLSessionDelegate>


+(instancetype)shareHelper;


//get请求
+(void)getWithURLString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FilureBlock)failureBlock;


//post请求
+(void)postWithURLString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FilureBlock)failureBlock;


@end
