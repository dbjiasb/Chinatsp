//
//  Collect.m
//  Chinatsp
//
//  Created by yuante on 13-4-24.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "Collect.h"

@implementation Collect

-(id)init
{
    self=[super init];
    if(self)
    {
    
    }
    return self;
}

-(void)dealloc
{
    self.title=nil;
    self.des=nil;
    [super dealloc];
}
@end
