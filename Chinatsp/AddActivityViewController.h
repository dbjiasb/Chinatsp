//
//  AddActivityViewController.h
//  Chinatsp
//
//  Created by yuante on 13-5-13.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddActivityViewController : UITableViewController<UITextFieldDelegate,UITextViewDelegate>
{
    UITextField *titleField;
    UITextField *startTimeField;
    UITextField *endTimeField;
    UITextView *desText;
    UITextField *senderField;
    UITextField *phoneField;
    UITextField *startAddrField;
    UITextField *endAddrField;
    UITableView *table;
    UIButton *startbtn;
    UIButton *endbtn;
    UIActivityIndicatorView *progressdialog;
    UIDatePicker *picker;
    UIToolbar *customBar;
    int selectTimeFlag;
}
@end
