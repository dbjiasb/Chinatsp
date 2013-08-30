//
//  ShowMapViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-23.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface ShowMapViewController : UIViewController<BMKMapViewDelegate>

@property(nonatomic,retain)BMKMapView *mMapView;
@property(nonatomic,retain)NSArray *pointArray;
@end
