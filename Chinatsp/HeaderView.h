//
//  HeaderView.h
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIButton
@property(nonatomic,copy)NSString *title;

-(void)setCustomViews:(BOOL)isOpen;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title isopen:(BOOL)isOpen;
@end
