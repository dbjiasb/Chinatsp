//
//  GasStation.h
//  Chinatsp
//
//  Created by Dragon on 13-8-29.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "Position.h"
//加油站

@interface GasStation : Position
@property (nonatomic, retain) NSArray *gasItems; //油价表

- (void)fillFromDictionary:(NSDictionary *)dic;

@end
