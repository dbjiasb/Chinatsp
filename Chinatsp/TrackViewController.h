//
//  TrackViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface TrackViewController : UIViewController<BMKMapViewDelegate,UIAlertViewDelegate>
{
    UIActivityIndicatorView *progressdialog;
    BMKMapView *mapview;
    BMKPointAnnotation* carAnnotation;
    UIButton *user_loc;
    UIButton *car_loc;
    UIButton *send_track;
    UIButton *send_start;
}

@end
