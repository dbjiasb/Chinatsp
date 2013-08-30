//
//  DestinationViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-16.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "CallOutAnnotationView.h"


@interface DestinationViewController : UIViewController<UITextFieldDelegate,BMKMapViewDelegate,BMKSearchDelegate,MapViewBtnClick>
{
    UITextField *input;
    UIActivityIndicatorView *progressdialog;
    BMKPointAnnotation* newannotation;
    BOOL isFlag;
}

@property(nonatomic,retain)BMKMapView *mMapview;
//@property(nonatomic,retain)BMKSearch *mKSearch;
@end
