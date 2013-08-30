//
//  WelcomeViewController.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "WelcomeViewController.h"
#import "config.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *logoview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
    if(iPhone5)
    {
        logoview.frame=CGRectMake(0.0, 0.0, 320.0f, 460.0f);
    }
    else
    {
        logoview.frame=CGRectMake(0.0, 0.0, 320.0, 548.0f);
    }
    self.view=logoview;
    [logoview release];
    [self performSelector:@selector(pushMainView) withObject:nil afterDelay:2.0];
	// Do any additional setup after loading the view.
}


-(void)pushMainView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
