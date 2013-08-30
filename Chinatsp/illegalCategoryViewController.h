//
//  LstypeListViewController.h
//  ChangAn
//
//  Created by yuante on 13-7-3.
//  Copyright (c) 2013年 yuante. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LstypeListDelegate <NSObject>

-(void)getLstype:(NSString *)name value:(NSString *)value;
-(void)getCarorg:(NSString *)name value:(NSString *)value;
-(void)getLsprefix:(NSString *)name;

@end

@interface illegalCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *lstypenames;
    NSArray *lstypevalues;
    NSArray *carorgvalues;
    NSArray *carorgnames;
    NSArray *lsprefix;
}
@property(nonatomic,assign)NSInteger flag;
@property(nonatomic,assign)id<LstypeListDelegate> delegate;
@end
