//
//  MapCell.h
//  Chinatsp
//
//  Created by yuante on 13-4-16.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCell : UIView
{
    UILabel *_maptitle;
}

@property(nonatomic,retain)UIButton *search;
@property(nonatomic,retain)UIButton *icloudy;
@property(nonatomic,retain)UILabel *maptitle;
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;
@end
