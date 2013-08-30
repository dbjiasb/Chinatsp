//
//  IllegalListViewController.h
//  ChangAn
//
//  Created by yuante on 13-7-3.
//  Copyright (c) 2013年 yuante. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IllegalListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *totalArray;
    UITableView *table;
    UIActivityIndicatorView *progressdialog;
}

@property(nonatomic,copy)NSString *lstype;
@property(nonatomic,copy)NSString *carorg;
@property(nonatomic,copy)NSString *lsprefixStr;
@property(nonatomic,copy)NSString *carNumStr;
@property(nonatomic,copy)NSString *engineNumStr;
@property(nonatomic,copy)NSString *frameStr;
@property(nonatomic,copy)NSString *indentifyStr;
@property(nonatomic,copy)NSString *cookie;

@end
