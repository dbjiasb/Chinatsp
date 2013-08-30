//
//  CalloutMapAnnotation.h
//  Chinatsp
//
//  Created by yuante on 13-4-16.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface CalloutMapAnnotation : NSObject<BMKAnnotation>
{
    CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    NSString *_addr;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic , copy) NSString *addr;

- (id)initWithLatitude:(CLLocationDegrees)latitude
andLongitude:(CLLocationDegrees)longitude addr:(NSString *)addr;
@end
