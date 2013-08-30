//
//  customAnnotation.m
//  Chinatsp
//
//  Created by yuante on 13-4-16.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#define  Arror_height 15

#import "CallOutAnnotationView.h"
#import <QuartzCore/QuartzCore.h>
#import "MapCell.h"
#import "UIHelper.h"
#import "Collect.h"

@interface CallOutAnnotationView ()

-(void)drawInContext:(CGContextRef)context;
- (void)getDrawPath:(CGContextRef)context;
@end

@implementation CallOutAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -60);
        self.frame = CGRectMake(0.0, 0.0, 290.0, 55.0);

        self.mapCell=[[[MapCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 290.0, 40.0)] autorelease];
        [self.mapCell.search addTarget:self action:@selector(searchData) forControlEvents:UIControlEventTouchUpInside];
        [self.mapCell.icloudy addTarget:self action:@selector(cloudyData) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mapCell];
    }
    return self;
}

-(void)searchData
{
    [self.delgete iSearchData:self.mapCell.latitude longitude:self.mapCell.longitude];
}

-(void)cloudyData
{
    Collect *collect=[[Collect alloc] init];
    collect.title=self.mapCell.maptitle.text;
    collect.lat=self.mapCell.latitude;
    collect.lon=self.mapCell.longitude;
    [self.delgete iCloudyData:collect];
    [collect release];
}

-(void)drawInContext:(CGContextRef)context
{
	
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:28.0/255.0 green:29.0/255.0 blue:31.0/255.0 alpha:0.7].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
    //    CGContextSetLineWidth(context, 1.0);
    //     CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //    [self getDrawPath:context];
    //    CGContextStrokePath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
	CGFloat radius = 6.0;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect),
    // midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
    
//    self.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.layer.shadowOpacity = 1.0;
//    //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
//    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)dealloc
{
    [super dealloc];
}

@end
