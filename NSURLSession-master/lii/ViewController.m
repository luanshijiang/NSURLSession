//
//  ViewController.m
//  lii
//
//  Created by 软件工程系01 on 17/2/23.
//  Copyright © 2017年 软件工程系01. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>
{
    NSData *dataM;


}


@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self Get;
    [self delegate];
 
}


//NSURLSession的GET请求
-(void)Get{

    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520&pwd=520&type=JSON"];
    
    
    //创建NSURLSession对象,调用shareSession方法，返回一个单例
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    //使用NSURLSessionDataTask，进行一般的get／post
    /**
     根据对象创建 Task 请求
     
     url  方法内部会自动将 URL 包装成一个请求对象（默认是 GET 请求）
     completionHandler  完成之后的回调（成功或失败）
     
     param data     返回的数据（响应体）
     param response 响应头
     param error    错误信息
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
     
        //解析服务器返回的数据
        NSLog(@"解析服务器返回的数据：%@\n",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        //默认在子线程中解析数据
        NSLog(@"所在线程：%@",[NSThread currentThread]);
        
        
    }];
    
    //发送请求
    [dataTask  resume];


}


//NSURLSession的POST请求
-(void)Post{
    
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];

    //创建request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"post";
    request.HTTPBody   = [@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //解析服务器返回的数据
        NSLog(@"解析服务器返回的数据：%@\n",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSLog(@"所在线程：%@",[NSThread currentThread]);
        
    }];

    [dataTask resume];
    

}


-(void)delegate{

    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];

    //创建request请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody   = [@"username=520&pwd=520&type=JSON"dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建会话，设置代理
    /*
     第一个参数：配置信息；
     第二个参数：设置代理；
     第三个参数；队列，如果参数为nil，默认在子线程中执行
     */
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];

    [dataTask resume];
}

//代理方法


-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{

    //子线程中执行
    NSLog(@"1接收到服务器响应的时候调用 -- %@", [NSThread currentThread]);
    
    self->dataM = [NSMutableData data];
    //默认情况下不接收数据
    //必须告诉系统是否接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);

}


-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{

    //子线程中执行
    NSLog(@"2接收到服务器响应的时候调用 -- %@", [NSThread currentThread]);

}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    NSLog(@"请求完成或者是失败的时候调用");
     NSLog(@"2接收到服务器响应的时候调用 -- %@", [NSThread currentThread]);
    //解析服务器返回数据
    NSLog(@"%@", [[NSString alloc] initWithData:self->dataM encoding:NSUTF8StringEncoding]);
}






//----------------NSURLSessionDataTask 简单下载-------------------
-(void)dataTaskDownload{

    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:
                                                    @"http://120.25.226.186:32812/resources/images/minion_01.png"]
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                     
                                     //解析数据
                                     UIImage *image = [UIImage imageWithData:data];
                                     //回到主线程设置图片
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         //回主线程刷新UI
                                         
                                     });
                                     
                                 }] resume];

}




-(void)downloadTask{


    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/images/minion_02.png"];
    //创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建会话请求
    //优点：该方法内部已经完成了边接收数据边写沙盒的操作，解决了内存飙升的问题
    NSURLSessionDownloadTask *downTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                            
     //默认存储到临时文件夹 tmp 中，需要剪切文件到 cache
   NSLog(@"%@", location);//目标位置
   NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:response.suggestedFilename];
                                                            
   /**
   fileURLWithPath:有协议头
   URLWithString:无协议头
    */
   [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];}];
    //发送请求
    [downTask resume];



}

/*
 dataTask 和 downloadTask 下载对比
 
 NSURLSessionDataTask
 下载文件可以实现离线断点下载，但是代码相对复杂
 NSURLSessionDownloadTask
 下载文件可以实现断点下载，但不能离线断点下载
 内部已经完成了边接收数据边写入沙盒的操作
 解决了下载大文件时的内存飙升问题
 */


@end
