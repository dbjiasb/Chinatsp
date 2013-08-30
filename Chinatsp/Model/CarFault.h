//
//  CarFault.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-26.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarFault : NSObject
@property(nonatomic,assign)long data;
@property(nonatomic,copy) NSString *state;
@property(nonatomic,retain) NSMutableArray *faultList;
@end
