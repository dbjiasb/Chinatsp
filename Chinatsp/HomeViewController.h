//
//  HomeViewController.h
//  Chinatsp
//
//  Created by yuante on 13-4-11.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDProgressView;

@interface HomeViewController : UIViewController
{
    UIImageView *carImg;
    UIImageView *carTireImg;
    UIImageView *doorImg;
    UIImageView *lightImg;
    UIImageView *maintainImg;
    UIImageView *left_up_doorImg;
    UIImageView *left_down_doorImg;
    UIImageView *right_up_doorImg;
    UIImageView *right_down_doorImg;
    UIImageView *left_up_tireImg;
    UIImageView *left_down_tireImg;
    UIImageView *right_up_tireImg;
    UIImageView *right_down_tireImg;
    UILabel *timetxt;
    UILabel *soiltxt;
    UILabel *lifetxt;
    DDProgressView *leftSoil;
    DDProgressView *soillife;
    UIActivityIndicatorView *progressdialog;
    
    UIButton *homeNaviBtn;
    UIImageView *circleView;
}
@end
