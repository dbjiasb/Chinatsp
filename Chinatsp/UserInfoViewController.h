//
//  UserInfoViewController.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-25.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIActivityIndicatorView *progressdialog;
    UITableView *table;
    NSMutableDictionary *tableNd;
    NSInteger clickFlag;
}
@end
