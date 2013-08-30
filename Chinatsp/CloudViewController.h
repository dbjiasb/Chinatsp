//
//  CloudViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-15.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingMoreFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface CloudViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView *table;
    NSMutableArray *totalArray;
    UIActivityIndicatorView *progressdialog;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@end
