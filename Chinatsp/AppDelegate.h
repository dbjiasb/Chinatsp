//
//  AppDelegate.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager *_mapManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *viewController;

@property (nonatomic, assign) CLLocationCoordinate2D usercoordinate;

@property(nonatomic,retain)BMKSearch *mKSearch;

@end
