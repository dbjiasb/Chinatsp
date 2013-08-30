//
//  CarStatus.h
//  Chinatsp
//
//  Created by yuante on 13-4-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarStatus : NSObject

@property(nonatomic,assign)NSInteger data;
@property(nonatomic,assign)NSInteger fuel;
@property(nonatomic,assign)NSInteger left_up_door;
@property(nonatomic,assign)NSInteger left_down_door;
@property(nonatomic,assign)NSInteger right_up_door;
@property(nonatomic,assign)NSInteger right_down_door;
@property(nonatomic,assign)NSInteger isHaveTire;
@property(nonatomic,assign)NSInteger left_up_tire_press;
@property(nonatomic,assign)NSInteger left_down_tire_press;
@property(nonatomic,assign)NSInteger right_up_tire_press;
@property(nonatomic,assign)NSInteger right_down_tire_press;
@property(nonatomic,assign)NSInteger dipped_beam_status;
@property(nonatomic,assign)NSInteger high_beam_status;
@end
