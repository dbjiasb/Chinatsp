//
//  Position.m
//  Chinatsp
//
//  Created by Dragon on 13-8-28.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "Position.h"

@protocol FillFromDictionary <NSObject>

- (void)fillFromDictionary:(NSDictionary *)dic;

@end

@implementation Position

- (id)init
{
    if (self = [super init])
    {
        self.last_modify_timestamp = @0;
        self.poi_id = @"";
        self.type = @0;
        self.title = @"";
        self.lat = @0;
        self.lng = @0;
        self.description = @"";
        self.tel = @"";
    }
    
    return self;
}

- (void)dealloc
{
    self.last_modify_timestamp = nil;
    self.poi_id = nil;
    self.type = nil;
    self.title = nil;
    self.lat = nil;
    self.lng = nil;
    self.description = nil;
    self.tel = nil;

    [super dealloc];
}

@end
