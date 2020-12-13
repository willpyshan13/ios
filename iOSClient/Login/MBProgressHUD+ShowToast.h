//
//  MBProgressHUD+ShowToast.h
//  appbox
//
//  Created by asfda on 2018/6/5.
//  Copyright © 2018年 dafdasfd. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (ShowToast)

+ (void)showToast:(NSString *)message;
+ (void)showToastOther:(NSString *)message;
+ (void)showToast:(NSString *)message afterDelay:(NSTimeInterval)delay;
@end
