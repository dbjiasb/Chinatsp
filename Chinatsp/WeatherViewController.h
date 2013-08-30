//
//  WeatherViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-15.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController
{
    UIActivityIndicatorView *progressdialog;
    UILabel *timelabel;
    UILabel *templabel;
    UILabel *weatherlabel;
    UILabel *windlable;
    UIImageView *weathericon;
    UILabel *humiditylabel;
    UILabel *publishitime;
    UILabel *list_today;
    UILabel *list_condition1;
    UILabel *list_temp1;
    UILabel *list_tommrroy;
    UILabel *list_condition2;
    UILabel *list_temp2;
    UILabel *list_aftertommrroy;
    UILabel *list_condition3;
    UILabel *list_temp3;
    UILabel *carconditonlabel;
    UILabel *clothconditionlabel;
    UILabel *airconditionlabel;
    UILabel *raylable;
}
@end
