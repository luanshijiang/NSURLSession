//
//  ViewController.m
//  WMNSURLSessionHelper
//
//  Created by 软件工程系01 on 17/3/18.
//  Copyright © 2017年 软件工程系01. All rights reserved.
//

#import "ViewController.h"
#import "WMNSURLSessionHelper.h"



typedef void (^SuccessBlock)(NSDictionary *data);
typedef void (^FilureBlock)(NSError *error);


@interface ViewController ()<NSURLSessionDataDelegate,NSURLSessionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-40, 80)];
    self.btn.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:self.btn];
    
    
      NSString *URLString       = @"url";
      NSDictionary *paramDicGet = @{@"username":@"Lili",@"password":@"123456",@"Method":@"login",@"mobile":@"mobile"};
      NSDictionary *paramDicPost = @{@"Method":@"changePwd",@"mobile":@"mobile",@"username":@"Lili",@"newPwd":@"123456"};
    
    
    //拼接出URL
    NSMutableString *mutableURL = [[NSMutableString alloc]initWithString:URLString];
    NSMutableString *str=[[NSMutableString alloc]init];
    if ([paramDicGet allKeys]) {
        
        [mutableURL appendString:@"?"];
        for (id key in paramDicGet) {
            
            NSString *value = [[paramDicGet objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
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
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
   
    //使用session开启数据任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //失败,输出失败信息;成功，返回dic
        if (error) {
          
        }else{
            
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            NSLog(@"get===%@",dic);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.btn setTitle:[dic objectForKey:@"userCode"] forState:UIControlStateNormal];
            });
        }
        
    }];
    //启动任务
    [dataTask resume];
    

    
//    
//    [WMNSURLSessionHelper getWithURLString:URLString parameters:paramDicGet success:^(NSDictionary *data) {
//        
//        NSDictionary *successDic= data;
//        NSLog(@"get数据成功=%@",successDic);
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"失败，原因=%@",error);
//        
//    }];
    
    
    [WMNSURLSessionHelper postWithURLString:URLString parameters:paramDicPost success:^(NSDictionary *data) {
        
        NSDictionary *postSuccessDic= data;
        NSLog(@"post数据成功=%@",postSuccessDic);
        
    } failure:^(NSError *error) {
    
        NSLog(@"失败，原因=%@",error);
        
    }];
    
}



@end
