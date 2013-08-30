//
//  RoadRescueViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface RoadRescueViewController : UIViewController<BMKMapViewDelegate,UIAlertViewDelegate>
{
    UIActivityIndicatorView *progressdialog;
    BMKMapView *mapview;
    BMKPointAnnotation* carAnnotation;
}
@end
