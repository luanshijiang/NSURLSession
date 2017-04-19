//
//  WMNSURLSessionHelper.m
//  WMNSURLSessionHelper
//
//  Created by 软件工程系01 on 17/3/18.
//  Copyright © 2017年 软件工程系01. All rights reserved.
//

#import "WMNSURLSessionHelper.h"

//定义一个静态变量
static WMNSURLSessionHelper *helper = nil;

@implementation WMNSURLSessionHelper

//使用单例，实例化对象
+(instancetype)shareHelper{

    @synchronized(self) {
        
        if (!helper) {
            
            helper = [[WMNSURLSessionHelper alloc]init];
            
        }
        
        return helper;
    }

}



//get请求
+(void)getWithURLString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FilureBlock)failureBlock{

     NSLog(@"get所在线程%@",[NSThread currentThread]);
    
    
    [self shareHelper];
    
    
    //拼接出URL
    NSMutableString *mutableURL = [[NSMutableString alloc]initWithString:url];
    NSMutableString *str=[[NSMutableString alloc]init];
    if ([parameters allKeys]) {
        
        [mutableURL appendString:@"?"];
        for (id key in parameters) {
            
                NSString *value = [[parameters objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
               [str appendString:[NSString stringWithFormat:@"&%@=%@",key,value]];
        }

        [mutableURL appendString:[str substringFromIndex:1]];
      
    }
    
    NSString *URLEncode     = [mutableURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"URLEncode=%@",URLEncode);
    
    //开始网络请求
    NSURLRequest *request   = [NSURLRequest requestWithURL:[NSURL URLWithString:URLEncode]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:helper delegateQueue:queue];
    
    //使用session开启数据任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //失败,输出失败信息;成功，返回dic
         if (error) {
             failureBlock(error);
          }else{
              
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
              successBlock(dic);
          }
        
       }];
    //启动任务
    [dataTask resume];

}


//post请求
+(void)postWithURLString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FilureBlock)failureBlock{
    
    NSLog(@"post所在线程%@",[NSThread currentThread]);
    [self shareHelper];
    
    NSURL *postURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL];
    
    //设置请求方式
    request.HTTPMethod = @"post";
    NSString *postStr  = [WMNSURLSessionHelper parseParams:parameters];
    
    //设置请求体
    request.HTTPBody        = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session   = [NSURLSession sessionWithConfiguration:config
                        delegate:helper
                   delegateQueue:queue];
    
    //使用session开启数据任务
    NSURLSessionDataTask *dataTask    = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            failureBlock(error);
        }else{
            //失败,输出失败信息;成功，返回dic
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            successBlock(dic);
        
        }
     }];
    [dataTask resume];
    

}


//把NSDictionary解析成post格式的NSString字符串
+(NSString *)parseParams:(NSDictionary *)params{

    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];

    
    //初始化一个枚举器,使用keyEnumerator获取所有键值
    NSEnumerator *keyEnum   = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[params objectForKey:key]];
        [result appendString:keyValueFormat];
        
    }
    
    return result;
}


#pragma mark -NSURLSessionDelegate 代理方法

//主要是处理HTTPS请求,
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{

     NSLog(@"代理--所在线程%@",[NSThread currentThread]);
    
    NSURLProtectionSpace *protactionSpace = challenge.protectionSpace;
    if ([protactionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        //获取服务器的trust object
        SecTrustRef serverTrust = protactionSpace.serverTrust;
        //认证成功，则创建一个凭证返回给服务器，completionHandler回调凭证，传递给服务器
        completionHandler(NSURLSessionAuthChallengeUseCredential,[NSURLCredential credentialForTrust:serverTrust]);
    }else{
    
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
    
    }
}



@end
