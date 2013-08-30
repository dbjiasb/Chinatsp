//
//  UINavigationBar+setBackground.m
//  Chinatsp
//
//  Created by yuante on 13-4-23.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "UINavigationBar+setBackground.h"

@implementation UINavigationBar (setBackground)

-(void)drawRect:(CGRect)rect
{
    UIImage *img=[UIImage imageNamed:@"nav_bar"];
    [img drawInRect:rect];
}
@end
