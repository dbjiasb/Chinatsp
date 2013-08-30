//
//  ContentCell.h
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol btnDeletegate <NSObject>

-(void)selectBtnClick:(id)sender;

@end

@interface ContentCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *detailTable;
}

@property(nonatomic,assign) id <btnDeletegate> clickelegate;
@property(nonatomic,retain)NSArray *detailArr;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contents:(NSArray *)contents;

-(void)setBoundsOfCell:(CGRect)bounds;
-(void)createDetailTableViewWithFrame:(CGRect)frame;
@end
