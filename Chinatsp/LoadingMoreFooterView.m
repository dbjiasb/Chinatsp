//
//  LoadingMoreFooterView.m
//  Miu Ptt
//
//  Created by Xingzhi Cheng on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingMoreFooterView.h"

@interface LoadingMoreFooterView()

@property(nonatomic, retain) UIActivityIndicatorView * activityView;
@property(nonatomic, readwrite) CGRect savedFrame;
@end

@implementation LoadingMoreFooterView
@synthesize textLabel = _textLabel;
//@synthesize activityView = _activityView;
@synthesize activityView;
@synthesize showActivityIndicator = _showActivityIndicator;
@synthesize refreshing = _refreshing;
@synthesize enabled = _enabled;
@synthesize savedFrame = _savedFrame;
@synthesize currentPageInLoadingMore;
@synthesize stateNum;


- (void) dealloc {
    self.textLabel = nil;
    self.activityView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentPageInLoadingMore=-1;
        self.showActivityIndicator = NO;
        self.enabled = YES;
        self.refreshing = NO;
        self.backgroundColor=[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
        self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width, frame.size.height)] autorelease];
        self.textLabel.textAlignment = UITextAlignmentCenter;
//        self.textLabel.text = NSLocalizedString(@"Pull to load more", @"Legen Sie mehr");
        
        self.textLabel.text = NSLocalizedString(@"上拉可以加载更多……", @"Legen Sie mehr");
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.textLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    self.savedFrame = frame;
    [super setFrame:frame];
}

- (void) setTextAlignment:(UITextAlignment)textAlignment {
    self.textLabel.textAlignment = textAlignment;
}

- (UITextAlignment) textAlignment {
    return self.textAlignment;
}

- (void) setShowActivityIndicator:(BOOL)showActivityIndicator 
{
    _showActivityIndicator = showActivityIndicator;
    if (showActivityIndicator && !self.activityView) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.center = CGPointMake(self.frame.size.width-40, self.frame.size.height / 2);
        self.activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite
        ;        [self addSubview:self.activityView];
        [self.activityView release];
        [self.activityView startAnimating];
        
        self.textLabel.text = NSLocalizedString(@"加载中……", @"Laden");
    }
    else if (!showActivityIndicator) {
        if (self.activityView) {
            [self.activityView stopAnimating];
            [self.activityView removeFromSuperview];
            self.activityView = nil;
        }
        if (self.currentPageInLoadingMore == 0) {
            self.textLabel.text = NSLocalizedString(@"亲，已经是最后一页了!", @"Legen Sie mehr");
        } 
        else {
            self.textLabel.text = NSLocalizedString(@"上拉可以加载更多……", @"Legen Sie mehr");
        }
    }
}

- (void) setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (enabled) {
        [super setFrame:self.savedFrame];
        self.hidden = NO;
    }
    else {
        [super setFrame:CGRectZero];
        self.hidden = YES;
    }
}

@end
