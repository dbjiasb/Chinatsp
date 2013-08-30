//
//  PlaceMark.h
//  Chinatsp
//
//  Created by yuante on 13-4-16.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface PlaceMark : NSObject<BMKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy)NSString *addr;

-(id)initWithCoord:(NSString *)addr Coord:(CLLocationCoordinate2D )coor;
@end
