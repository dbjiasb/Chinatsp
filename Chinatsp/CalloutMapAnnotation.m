//
//  CalloutMapAnnotation.m
//  Chinatsp
//
//  Created by yuante on 13-4-16.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation

-(id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude addr:(NSString *)addr
{
    if(self=[super init])
    {
        self.latitude=latitude;
        self.longitude=longitude;
        self.addr=addr;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

-(void)dealloc
{
    self.addr=nil;
    [super dealloc];
}
@end
