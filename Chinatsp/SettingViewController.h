//
//  SettingViewController.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface SettingViewController : UIViewController<MFMessageComposeViewControllerDelegate>
{
    UIActivityIndicatorView *progressdialog;
}
@end
