//
//  HeaderView.m
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title isopen:(BOOL)isOpen
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title=title;
        [self setCustomViews:isOpen];
        self.exclusiveTouch=YES;
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setCustomViews:(BOOL)isOpen
{
    
    UIImage *bgimage=nil;
    if (isOpen) {
        bgimage=[UIImage imageNamed:@"diagnois_header"];
    }else
    {
        bgimage=[UIImage imageNamed:@"head_bg"];
    }
    [self setBackgroundImage:bgimage forState:UIControlStateNormal];
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(10.0, (45.0-30.0)/2, 250.0, 30.0)];
    lable.backgroundColor=[UIColor clearColor];
    lable.text=self.title;
    lable.textColor=[UIColor whiteColor];
    [self addSubview:lable];
    [lable release];
}

-(void)dealloc
{
    self.title=nil;
    [super dealloc];
}
@end
