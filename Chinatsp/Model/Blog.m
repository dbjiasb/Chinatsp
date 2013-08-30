//
//  Blog.m
//  Chinatsp
//
//  Created by yuante on 13-4-24.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "Blog.h"

@implementation Blog
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
    self.time=nil;
    self.brief=nil;
    self.from=nil;
    self.description=nil;
    self.name=nil;
    self.phone=nil;
    [super dealloc];
}
@end
