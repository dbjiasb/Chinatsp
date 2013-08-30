//
//  CommentViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-14.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSMutableArray *totalArray;
    UIActivityIndicatorView *progressdialog;
    int selectFlag;
}
@end
