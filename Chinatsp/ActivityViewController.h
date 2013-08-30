//
//  ActivityViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-17.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@class LoadingMoreFooterView;

@interface ActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UIActivityIndicatorView *progressdialog;
    EGORefreshTableHeaderView *_refreshHeaderView;
    UITableView *table;
    NSMutableArray *totalarray;
    int pageNum;
    int selectFlag;
    BOOL isLastPage;
    BOOL isLoad;
    BOOL _reloading;
    BOOL isShownet;
    UIView *netalertview;
}
@property(nonatomic,retain) LoadingMoreFooterView *loadFooterView;
@end
