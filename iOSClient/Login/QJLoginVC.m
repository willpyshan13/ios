//
//  QJLoginVC.m
//  Nextcloud
//
//  Created by cc2 on 2020/12/6.
//  Copyright © 2020 Marino Faggiana. All rights reserved.
//

#import "QJLoginVC.h"
#import "AppDelegate.h"
#import "CCUtility.h"
#import "NCBridgeSwift.h"
#import "MBProgressHUD+ShowToast.h"
#import "QJForgotPasswordVC.h"

@interface QJLoginVC ()<NCLoginQRCodeDelegate>
{
    AppDelegate *appDelegate;
    UIView *rootView;
    UIColor *textColor;
    UIColor *textColorOpponent;
}

@end

@implementation QJLoginVC

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
    
    // Base URL
    _baseUrlTF.textColor = textColor;
    _baseUrlTF.tintColor = textColor;
    _baseUrlTF.placeholder = NSLocalizedString(@"_login_url_", nil);
    UILabel *baseUrlPlaceholder = object_getIvar(_baseUrlTF, ivar);
    baseUrlPlaceholder.textColor = [textColor colorWithAlphaComponent:0.5];
    [self.baseUrlTF setFont:[UIFont systemFontOfSize:14]];
    [self.baseUrlTF setDelegate:self];
    
    // User
    _userTF.textColor = textColor;
    _userTF.tintColor = textColor;
    _userTF.placeholder = NSLocalizedString(@"_username_", nil);
    UILabel *userPlaceholder = object_getIvar(_userTF, ivar);
    userPlaceholder.textColor = [textColor colorWithAlphaComponent:0.5];

    [self.userTF setFont:[UIFont systemFontOfSize:14]];
    [self.userTF setDelegate:self];

    // Password
    _passwordTF.textColor = textColor;
    _passwordTF.tintColor = textColor;
    _passwordTF.placeholder = NSLocalizedString(@"_password_", nil);
    UILabel *passwordPlaceholder = object_getIvar(_passwordTF, ivar);
    passwordPlaceholder.textColor = [textColor colorWithAlphaComponent:0.5];
    [self.passwordTF setFont:[UIFont systemFontOfSize:14]];
    [self.passwordTF setDelegate:self];

    
    // Login
    [self.loginBtn setTitle:NSLocalizedString(@"_login_", nil) forState:UIControlStateNormal] ;
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = HEXCOLOR(0x3880C3);//
//    self.loginBtn.tintColor = textColorOpponent;
    self.loginBtn.layer.cornerRadius = 25;
    self.loginBtn.clipsToBounds = YES;
    
    [self.forgetBtn setTitle:NSLocalizedString(@"_forgot_password_", nil) forState:UIControlStateNormal] ;

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
#pragma mark == TextField ==
#pragma --------------------------------------------------------------------------------------------

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.passwordTF) {
        self.passwordTF.defaultTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:textColor};
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.passwordTF) {
        self.passwordTF.defaultTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:textColor};
    }
}

#pragma --------------------------------------------------------------------------------------------
#pragma mark === NCLoginQRCodeDelegate ===
#pragma --------------------------------------------------------------------------------------------

- (void)dismissQRCode:(NSString *)value metadataType:(NSString *)metadataType
{
    self.baseUrlTF.text = value;
}

#pragma --------------------------------------------------------------------------------------------
#pragma mark == Login ==
#pragma --------------------------------------------------------------------------------------------


- (IBAction)handleButtonLogin:(id)sender
{
    if ([self.baseUrlTF.text length] == 0) {
        [MBProgressHUD showToast:NSLocalizedString(@"_login_url_", nil)];
        return;
    }
    
    if ([self.userTF.text length] == 0) {
        [MBProgressHUD showToast:NSLocalizedString(@"_username_", nil)];
        return;
    }
    
    if ([self.passwordTF.text length] == 0) {
        [MBProgressHUD showToast:NSLocalizedString(@"_password_", nil)];
        return;
    }
    
    if ([self.baseUrlTF.text length] > 0 && [self.userTF.text length] && [self.passwordTF.text length]) {
        
        // remove last char if /
        if ([[self.baseUrlTF.text substringFromIndex:[self.baseUrlTF.text length] - 1] isEqualToString:@"/"])
            self.baseUrlTF.text = [self.baseUrlTF.text substringToIndex:[self.baseUrlTF.text length] - 1];
        
        NSString *url = self.baseUrlTF.text;
        NSString *user = self.userTF.text;
        NSString *password = self.passwordTF.text;
        
        self.loginBtn.enabled = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [[NCCommunication shared] getAppPasswordWithServerUrl:url username:user password:password customUserAgent:nil completionHandler:^(NSString *token, NSInteger errorCode, NSString *errorDescription) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.loginBtn.enabled = YES;
            
            [self AfterLoginWithUrl:url user:user token:token errorCode:errorCode message:errorDescription];
        }];
    }
}

- (void)AfterLoginWithUrl:(NSString *)url user:(NSString *)user token:(NSString *)token errorCode:(NSInteger)errorCode message:(NSString *)message
{
    if (errorCode == 0) {
        
        NSString *account = [NSString stringWithFormat:@"%@ %@", user, url];
        
        // NO account found, clear
        if ([NCManageDatabase.sharedInstance getAccounts] == nil) { [NCUtility.shared removeAllSettings]; }
        
        [[NCManageDatabase sharedInstance] deleteAccount:account];
        [[NCManageDatabase sharedInstance] addAccount:account urlBase:url user:user password:token];
        
        tableAccount *tableAccount = [[NCManageDatabase sharedInstance] setAccountActive:account];
        
        // Setting appDelegate active account
        [appDelegate settingAccount:tableAccount.account urlBase:tableAccount.urlBase user:tableAccount.user userID:tableAccount.userID password:[CCUtility getPassword:tableAccount.account]];
        
        if ([CCUtility getIntro]) {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:k_notificationCenter_initializeMain object:nil userInfo:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [CCUtility setIntro:YES];
            if (self.presentingViewController == nil) {
                UISplitViewController *splitController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
                splitController.modalPresentationStyle = UIModalPresentationFullScreen;
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:k_notificationCenter_initializeMain object:nil userInfo:nil];
                appDelegate.window.rootViewController = splitController;
                [appDelegate.window makeKeyWindow];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:k_notificationCenter_initializeMain object:nil userInfo:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } else {
        if (errorCode != NSURLErrorServerCertificateUntrusted) {
            NSString *messageAlert = [NSString stringWithFormat:@"%@.\n%@", NSLocalizedString(@"_not_possible_connect_to_server_", nil), message];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"_error_", nil) message:messageAlert preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"_ok_", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (IBAction)handleQRCode:(id)sender
{
    NCLoginQRCode *qrCode = [[NCLoginQRCode alloc] initWithDelegate:self];
    
    [qrCode scan];
}


- (IBAction)didToResetPasswordAction:(id)sender {
    QJForgotPasswordVC *vc = [[QJForgotPasswordVC alloc] initWithNibName:@"QJForgotPasswordVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
