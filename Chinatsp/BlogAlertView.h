//
//  BlogAlertView.h
//  Chinatsp
//
//  Created by yuante on 13-4-19.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogAlertView : UIAlertView<UITextViewDelegate>

@property(nonatomic,retain)UITextView *input;
@end
