//
//  CarWashing.m
//  Chinatsp
//
//  Created by Dragon on 13-8-29.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "CarWashing.h"

@implementation CarWashing

- (id)init
{
    if (self = [super init])
    {
        self.price = @0;
    }
    return self;
}

- (void)fillFromDictionary:(NSDictionary *)dic
{
    self.last_modify_timestamp = !ISNULL([dic objectForKey:@"last_modify_timestamp"]) ? [dic objectForKey:@"last_modify_timestamp"] : @0;
    self.type = !ISNULL([dic objectForKey:@"type"]) ? [dic objectForKey:@"type"] : @0;
    self.poi_id = !ISNULL([dic objectForKey:@"poi_id"]) ? [dic objectForKey:@"poi_id"] : @"";
    
    if (!ISNULL([dic objectForKey:@"poi_content"]))
    {
        NSDictionary *contentDic = [dic objectForKey:@"poi_content"];
        NSLog(@"%@",contentDic);
        self.title = !ISNULL([contentDic objectForKey:@"title"]) ? [contentDic objectForKey:@"title"] : @"";
        self.lat = !ISNULL([contentDic objectForKey:@"lat"]) ? [contentDic objectForKey:@"lat"] : @0;
        self.lng = !ISNULL([contentDic objectForKey:@"lng"]) ? [contentDic objectForKey:@"lng"] : @0;
        self.description = !ISNULL([contentDic objectForKey:@"description"]) ? [contentDic objectForKey:@"description"] : @"";
        self.tel = !ISNULL([contentDic objectForKey:@"tel"]) ? [contentDic objectForKey:@"tel"] : @"";
        self.price = !ISNULL([contentDic objectForKey:@"other"]) ? [contentDic objectForKey:@"other"] : @0;
    }
}

- (void) dealloc
{
    self.price = nil;
    
    [super dealloc];
}

@end
