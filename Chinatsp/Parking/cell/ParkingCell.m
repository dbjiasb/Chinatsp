//
//  ParkingCell.m
//  Chinatsp
//
//  Created by Dragon on 13-8-29.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "ParkingCell.h"

@implementation ParkingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (ParkingCell *)parkingCell
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"ParkingCell" owner:self options:nil];
    
    ParkingCell *parkingCell = [nibViews objectAtIndex:0];
    parkingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:productHeadView action:@selector(handleSwipeFrom:)];
    //
    //    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    //    [productHeadView addGestureRecognizer:recognizer];
    //    [recognizer release];
    
    
    return parkingCell;
}

@end
