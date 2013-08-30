//
//  PlaceMark.m
//  Chinatsp
//
//  Created by yuante on 13-4-16.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "PlaceMark.h"

@implementation PlaceMark

-(id)initWithCoord:(NSString *)addr Coord:(CLLocationCoordinate2D)coor
{
    self=[super init];
    if(self)
    {
        self.coordinate=coor;
        self.addr=addr;
    }
    return self;
}

-(void)dealloc
{
    self.addr=nil;
    [super dealloc];
}
@end
