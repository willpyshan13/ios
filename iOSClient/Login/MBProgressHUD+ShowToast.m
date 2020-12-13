//
//  MBProgressHUD+ShowToast.m
//  appbox
//
//  Created by asfda on 2018/6/5.
//  Copyright © 2018年 dafdasfd. All rights reserved.
//

#import "MBProgressHUD+ShowToast.h"

@implementation MBProgressHUD (ShowToast)

+ (void)showToast:(NSString *)message {
    

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    CGFloat height = [UIScreen mainScreen].bounds.size.height/4.0;
    hud.offset = CGPointMake(0.f, height);
    [hud hideAnimated:YES afterDelay:1.5f];

}

+ (void)showToastOther:(NSString *)message {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    CGFloat height = [UIScreen mainScreen].bounds.size.height/4.0;
    hud.offset = CGPointMake(0.f, height);
    [hud hideAnimated:YES afterDelay:1.5f];
    
}

+ (void)showToast:(NSString *)message afterDelay:(NSTimeInterval)delay {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    CGFloat height = [UIScreen mainScreen].bounds.size.height/4.0;
    hud.offset = CGPointMake(0.f, height);
    [hud hideAnimated:YES afterDelay:delay];
}

@end
