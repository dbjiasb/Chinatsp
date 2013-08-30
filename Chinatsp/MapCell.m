//
//  MapCell.m
//  Chinatsp
//
//  Created by yuante on 13-4-16.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "MapCell.h"

@implementation MapCell
@synthesize maptitle=_maptitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView *searchimg=[[[UIImageView alloc] initWithFrame:CGRectMake(6.0, 7.0, 28.0,26.0)] autorelease];
        [searchimg setImage:[UIImage imageNamed:@"dest_serch"]];
        [self addSubview:searchimg];
        UIImageView *cloudyimg=[[[UIImageView alloc] initWithFrame:CGRectMake(254.0, 7.0, 28, 23)] autorelease];
        [cloudyimg setImage:[UIImage imageNamed:@"dest_cloud"]];
        [self addSubview:cloudyimg];
        self.search=[UIButton buttonWithType:UIButtonTypeCustom];
        self.search.frame=CGRectMake(0.0, 0.0, 50.0,40.0);
        [self addSubview:self.search];
        UIView *view=[[[UIView alloc] initWithFrame:CGRectMake(41.0, 4.0, 1.0, 32.0)] autorelease];
        view.backgroundColor=[UIColor whiteColor];
        [self addSubview:view];
        
        _maptitle=[[UILabel alloc] initWithFrame:CGRectMake(46.0,7.0, 200.0, 25.0)];
        _maptitle.textColor=[UIColor whiteColor];
        _maptitle.backgroundColor=[UIColor clearColor];
        [self addSubview:_maptitle];
        [_maptitle release];
        
        UIView *view1=[[[UIView alloc] initWithFrame:CGRectMake(248.0, 4.0, 1.0, 32.0)] autorelease];
        view1.backgroundColor=[UIColor whiteColor];
        [self addSubview:view1];
        
        self.icloudy=[UIButton buttonWithType:UIButtonTypeCustom];
        self.icloudy.frame=CGRectMake(240.0, 0.0, 50.0, 40.0);
        [self addSubview:self.icloudy];
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

@end
