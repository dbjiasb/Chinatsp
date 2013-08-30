//
//  IllegalViewController.h
//  ChangAn
//
//  Created by yuante on 13-6-21.
//  Copyright (c) 2013年 yuante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "illegalCategoryViewController.h"

@interface IllegalViewController : UIViewController<UITextFieldDelegate,LstypeListDelegate>
{
    UITextField *trafficeer;
    UITextField *numType;
    UITextField *carCity;
    UITextField *carNum;
    UITextField *engineNum;
    UITextField *frameNum;
    UIImageView *indentifyImg;
    UITextField *indentifyCode;
    UILabel *errorindentify;
    UIActivityIndicatorView *progressdialog;
    BOOL isLoad;
}
@property(nonatomic,copy)NSString *selectlstype;
@property(nonatomic,copy)NSString *selectcarorg;
@property(nonatomic,copy)NSString *lsprefixStr;
@property(nonatomic,copy)NSString *carNumStr;
@property(nonatomic,copy)NSString *engineNumStr;
@property(nonatomic,copy)NSString *frameStr;
@property(nonatomic,copy)NSString *indentifyStr;
@property(nonatomic,copy)NSString *cookie;
@end
