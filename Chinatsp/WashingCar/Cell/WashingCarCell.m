//
//  WashingCarCell.m
//  Chinatsp
//
//  Created by yuante on 13-8-28.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "WashingCarCell.h"

@implementation WashingCarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WashingCarCell *)washingCarCell
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"WashingCarCell" owner:self options:nil];
    
    WashingCarCell *washingCarCell = [nibViews objectAtIndex:0];
    washingCarCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:productHeadView action:@selector(handleSwipeFrom:)];
    //
    //    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    //    [productHeadView addGestureRecognizer:recognizer];
    //    [recognizer release];
    
    
    return washingCarCell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
