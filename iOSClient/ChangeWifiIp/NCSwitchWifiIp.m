//
//  NCSwitchWifiIp.m
//  Nextcloud
//
//  Created by cc2 on 2020/11/28.
//  Copyright © 2020 Marino Faggiana. All rights reserved.
//

#import "NCSwitchWifiIp.h"
#import "NCBridgeSwift.h"
#import "ZVGlobalData.h"

@implementation NCSwitchWifiIp

+ (void)checkBaseUrl {
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    if (appdelegate.urlBase.length > 0) {
        
        NSString *urlstring = [NSString stringWithFormat:@"%@/index.php/apps/registration/get_inner_ip",appdelegate.urlBase];
        
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        //设置请求类型
        request.HTTPMethod = @"GET";
    //    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];//请求头

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                
            } else {
                //请求成功
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (dic && [dic isKindOfClass:NSDictionary.class]) {
                        NSString *status = dic[@"status"];
                        NSString *result = dic[@"result"];
                        if ([status isEqualToString:@"ok"] && result && result.length > 0) {
                            appdelegate.wifiUrlIp = result;
                            [self checkEnableUrl];
                        }
                    }

                });


            }
        }];
        [dataTask resume];  //开始请求
    }
    
}


+ (void)checkEnableUrl {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSString *urlstring = [NSString stringWithFormat:@"http://%@/index.php/apps/registration/get_status",appdelegate.wifiUrlIp];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //设置请求类型
    request.HTTPMethod = @"GET";
//    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];//请求头

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            
        } else {
            //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                if (dic && [dic isKindOfClass:NSDictionary.class]) {
                    NSString *status = dic[@"status"];
                    
//                    if (status && [status isEqualToString:@"ok"]) {
//                        appdelegate.isOK = YES;
//                    }
                } else {
                }

            });


        }
    }];
    [dataTask resume];  //开始请求
    
}

+ (void)getShareData {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSString *urlstring = [NSString stringWithFormat:@"%@/ocs/v1.php/apps/files_sharing/api/v1/shares?format=xml&shared_with_me=false&include_tags=true",appdelegate.urlBase];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //设置请求类型
    request.HTTPMethod = @"GET";
//    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];//请求头

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            
        } else {
            //请求成功
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                if (dic && [dic isKindOfClass:NSDictionary.class]) {
                    NSString *status = dic[@"status"];
                    
                    if (status && [status isEqualToString:@"ok"]) {
                        appdelegate.isOK = YES;
                    }
                } else {
                }

            });


        }
    }];
    [dataTask resume];  //开始请求
}

@end
