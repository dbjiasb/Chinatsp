//
//  CategoryViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface CategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BMKSearchDelegate>
{
    NSArray *categoryArray;
    UITableView *categoryTable;
    UIActivityIndicatorView *progressdialog;
    NSString *selectTitle;
}
//@property(nonatomic,retain)BMKSearch *mKSearch;
@property(nonatomic,retain)NSNumber *latitude;
@property(nonatomic,retain)NSNumber *longitude;

@end
