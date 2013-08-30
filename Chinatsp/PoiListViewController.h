//
//  PoiListViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-23.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoiListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    UIActivityIndicatorView *progressdialog;
}
@property(nonatomic,retain)NSArray *listArray;
@property(nonatomic,retain)NSArray *annoArray;
@property(nonatomic,copy)NSString *title;
@end
