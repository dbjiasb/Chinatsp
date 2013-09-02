//
//  ParkingCell.h
//  Chinatsp
//
//  Created by Dragon on 13-8-29.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkingCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *addrLabel;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;

+ (ParkingCell *)parkingCell;


@end
