//
//  CarFault.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-26.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "CarFault.h"

@implementation CarFault

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.faultList=[[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

-(void)dealloc
{
    self.faultList=nil;
    self.state=nil;
    [super dealloc];
}
@end
