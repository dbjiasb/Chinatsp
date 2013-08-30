//
//  CarWashing.h
//  Chinatsp
//
//  Created by Dragon on 13-8-29.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "Position.h"
//洗车场
@interface CarWashing : Position

@property (nonatomic,retain) NSNumber *price; //价格

- (void)fillFromDictionary:(NSDictionary *)dic;


@end
