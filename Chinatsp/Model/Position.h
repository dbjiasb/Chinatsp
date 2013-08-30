//
//  Position.h
//  Chinatsp
//
//  Created by Dragon on 13-8-28.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <Foundation/Foundation.h>
//目的地基类
@interface Position : NSObject
@property (nonatomic, retain) NSString *poi_id; //唯一值
@property (nonatomic, retain) NSNumber *type; //类型     洗车 1  加油站 2 停车  3
@property (nonatomic, retain) NSNumber *last_modify_timestamp; //最后修改时间
@property (nonatomic, retain) NSString *title; //名称
@property (nonatomic, retain) NSNumber *lat; //维度
@property (nonatomic, retain) NSNumber *lng; //经度
@property (nonatomic, retain) NSString *description; //描述
@property (nonatomic, retain) NSString *tel; //电话
@property (nonatomic, retain) NSString *addr; //地址
@end
