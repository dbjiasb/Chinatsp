//
//  RemoteCheckCell.m
//  Chinatsp
//
//  Created by yuante on 13-8-30.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "RemoteCheckCell.h"

@implementation RemoteCheckCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


+ (RemoteCheckCell *)remoteCheckCell
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"RemoteCheckCell" owner:self options:nil];
    
    RemoteCheckCell *remoteCheckCell = [nibViews objectAtIndex:0];
    remoteCheckCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:productHeadView action:@selector(handleSwipeFrom:)];
    //
    //    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    //    [productHeadView addGestureRecognizer:recognizer];
    //    [recognizer release];
    
    
    return remoteCheckCell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
