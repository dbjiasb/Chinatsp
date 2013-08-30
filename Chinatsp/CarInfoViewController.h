//
//  CarInfoViewController.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-25.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *table;
    UIActivityIndicatorView *progressdialog;
    NSMutableDictionary *tableNd;
    NSInteger clickFlag;
}
@end
