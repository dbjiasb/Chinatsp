//
//  LoginViewController.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *nameField;
    UITextField *passwordField;
    UIActivityIndicatorView *progressdialog;
}
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *pwd;
@end
