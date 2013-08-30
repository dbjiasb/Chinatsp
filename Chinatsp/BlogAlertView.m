//
//  BlogAlertView.m
//  Chinatsp
//
//  Created by yuante on 13-4-19.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "BlogAlertView.h"

@implementation BlogAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    if (self) {
        // Initialization code
        UITextView *teminput=[[[UITextView alloc] initWithFrame:CGRectMake(22, 45.0,240.0, 120.0)] autorelease];
        teminput.font=[UIFont systemFontOfSize:14.0];
        teminput.backgroundColor=[UIColor whiteColor];
        [teminput becomeFirstResponder];
        teminput.delegate=self;
        self.input=teminput;
        [self addSubview:self.input];
    }
    return self;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [self resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UIButton class]]||[view isKindOfClass:NSClassFromString(@"UIThreePartButton")])
        {
            CGRect btnBouds=view.frame;
            btnBouds.origin.y=self.input.frame.origin.y+self.input.frame.size.height+7.0;
            view.frame=btnBouds;
        }
    }
    CGRect bounds=self.frame;
    bounds.size.height=260.0;
    self.frame=bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
