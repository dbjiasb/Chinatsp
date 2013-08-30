//
//  DiagnosisViewController.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-26.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@class LoadingMoreFooterView;

@interface DiagnosisViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView *table;
    UIActivityIndicatorView *progressdialog;
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIView *netalertview;
    int selectFlag;
    NSMutableArray *dataArray;
    int pageNum;
    BOOL isLastPage;
    BOOL isLoad;
    BOOL _reloading;
    BOOL isShownet;
}
@property(nonatomic,retain) LoadingMoreFooterView *loadFooterView;
@end
