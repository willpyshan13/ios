//
//  QJLoginVC.m
//  Nextcloud
//
//  Created by cc2 on 2020/12/6.
//  Copyright © 2020 Marino Faggiana. All rights reserved.
//

#import "QJForgotPasswordVC.h"
#import "AppDelegate.h"
#import "CCUtility.h"
#import "NCBridgeSwift.h"
#import "MBProgressHUD+ShowToast.h"

@interface QJForgotPasswordVC ()
{
    AppDelegate *appDelegate;
    UIView *rootView;
    UIColor *textColor;
    UIColor *textColorOpponent;
}

@end

@implementation QJForgotPasswordVC

#pragma --------------------------------------------------------------------------------------------
#pragma mark ===== Init =====
#pragma --------------------------------------------------------------------------------------------

-  (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])  {
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");

    // Background color
//    self.view.backgroundColor = NCBrandColor.sharedInstance.customer;
    
    // Text Color
    BOOL isTooLight = NCBrandColor.sharedInstance.customer.isTooLight;
    BOOL isTooDark = NCBrandColor.sharedInstance.customer.isTooDark;
    if (isTooLight) {
        textColor = [UIColor blackColor];
        textColorOpponent = [UIColor whiteColor];
    } else if (isTooDark) {
        textColor = [UIColor whiteColor];
        textColorOpponent = [UIColor blackColor];
    } else {
        textColor = [UIColor blackColor];
        textColorOpponent = [UIColor whiteColor];
    }
    
    // Image Brand
    self.imageBrand.image = [UIImage imageNamed:@"logo1"];
    
    
    // User
    _userTF.textColor = textColor;
    _userTF.tintColor = textColor;
    _userTF.placeholder = NSLocalizedString(@"_username_", nil);
    UILabel *userPlaceholder = object_getIvar(_userTF, ivar);
    userPlaceholder.textColor = [textColor colorWithAlphaComponent:0.5];

    [self.userTF setFont:[UIFont systemFontOfSize:14]];
    [self.userTF setDelegate:self];

  
    // Login
    [self.loginBtn setTitle:NSLocalizedString(@"_back_login_", nil) forState:UIControlStateNormal] ;
//    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.loginBtn.backgroundColor = HEXCOLOR(0x3880C3);//
//    self.loginBtn.tintColor = textColorOpponent;
    self.loginBtn.layer.cornerRadius = 25;
    self.loginBtn.clipsToBounds = YES;
    
    [self.forgotBtn setTitle:NSLocalizedString(@"_reset_password_", nil) forState:UIControlStateNormal] ;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Stop timer error network
    [appDelegate.timerErrorNetworking invalidate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Start timer
    [appDelegate startTimerErrorNetworking];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}



#pragma --------------------------------------------------------------------------------------------
#pragma mark == Login ==
#pragma --------------------------------------------------------------------------------------------


- (IBAction)resetPasswordAction:(id)sender
{
   
}

- (IBAction)toLoginAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
