//
//  ViolationViewController.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-27.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViolationViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField *carNumField1;
//    UITextField *carNumField2;
//    UITextField *carNumField3;
    UITextField *carEngineField;
    UIButton *cityBtn;
    UIPickerView *pickerView;
    NSArray *array;
    UIToolbar *custombar;
    UITableView *table;
    UIActivityIndicatorView *progressdialog;
    NSMutableArray *volatilearray;
}
@property(nonatomic,copy)NSString *carNum;
@property(nonatomic,copy)NSString *carEngineNum;
@end
