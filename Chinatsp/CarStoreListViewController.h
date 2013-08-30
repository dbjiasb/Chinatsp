//
//  CarStoreListViewController.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-27.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadingMoreFooterView;

@interface CarStoreListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSMutableArray *array;
    UIActivityIndicatorView *progressdialog;
    UIView *netalertview;
    int pageNum;
    BOOL isLastPage;
    BOOL isLoad;
    BOOL isShownet;
}

@property(nonatomic,retain) LoadingMoreFooterView *loadFooterView;
@property(nonatomic,assign)BOOL notShowHome;
@end
