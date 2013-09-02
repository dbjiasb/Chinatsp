//
//  ParkingLot.h
//  Chinatsp
//
//  Created by Dragon on 13-8-29.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "Position.h"

@interface ParkingLot : Position

@property (nonatomic, retain) NSNumber *remainCount;//剩余车位
@property (nonatomic, retain) NSNumber *pricePerHour;//每小时费用

- (void)fillFromDictionary:(NSDictionary *)dic;

@end
