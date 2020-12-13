//
//  QJLoginVC.h
//  Nextcloud
//
//  Created by cc2 on 2020/12/6.
//  Copyright © 2020 Marino Faggiana. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QJForgotPasswordVC : UIViewController<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageBrand;

@property (nonatomic, weak) IBOutlet UITextField *userTF;

@property (nonatomic, weak) IBOutlet UIButton *loginBtn;
@property (nonatomic, weak) IBOutlet UIButton *forgotBtn;

@end

NS_ASSUME_NONNULL_END
