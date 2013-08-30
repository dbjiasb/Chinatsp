//
//  customAnnotation.h
//  Chinatsp
//
//  Created by yuante on 13-4-16.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

@class MapCell;
@class Collect;
#import "BMKAnnotationView.h"

@protocol MapViewBtnClick <NSObject>

-(void)iCloudyData:(Collect *)collect;
-(void)iSearchData:(double)latitude longitude:(double)longitude;

@end

@interface CallOutAnnotationView : BMKAnnotationView

@property(nonatomic,retain)MapCell *mapCell;
@property(nonatomic,assign)id<MapViewBtnClick> delgete;

@end
