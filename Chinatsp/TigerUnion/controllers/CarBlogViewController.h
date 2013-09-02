//
//  CarBlogViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-17.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

/*
   车博分享
 */
@class  LoadingMoreFooterView;
@interface CarBlogViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UIActivityIndicatorView *progressdialog;
    EGORefreshTableHeaderView *_refreshHeaderView;
    UITableView *table;
    UIView *netalertview;
    NSMutableArray *totalarray;
    int pageNum;
    BOOL isLastPage;
    BOOL isLoad;
    BOOL _reloading;
    BOOL isShownet;
}
@property(nonatomic,retain) LoadingMoreFooterView *loadFooterView;
@end
