//
//  AddBlogViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-24.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBlogViewController : UIViewController<UITextViewDelegate>
{
    UITextView *contentInput;
    UIActivityIndicatorView *progressdialog;
}

@end
