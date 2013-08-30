//
//  SaferTabViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "SaferTabViewController.h"
#import "DiagnosisViewController.h"
#import "RemoteControlViewController.h"
#import "RoadRescueViewController.h"
#import "TrackViewController.h"
#import "config.h"

@interface SaferTabViewController ()

@end

@implementation SaferTabViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        selectflag=0;
        self.tabBar.hidden=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    buttons=[[NSMutableArray alloc] initWithCapacity:4];
    DiagnosisViewController *diagnosis=[[DiagnosisViewController alloc] init];
    
    RemoteControlViewController *remote=[[RemoteControlViewController alloc] init];
    
    RoadRescueViewController *road=[[RoadRescueViewController alloc] init];
    
    TrackViewController *track=[[TrackViewController alloc] init];
    UINavigationController *remotenav=[[UINavigationController alloc] initWithRootViewController:remote];
    UINavigationController *diagnosisnav=[[UINavigationController alloc] initWithRootViewController:diagnosis];
    UINavigationController *roadnav=[[UINavigationController alloc] initWithRootViewController:road];
    UINavigationController *tracknav=[[UINavigationController alloc] initWithRootViewController:track];
    if([remotenav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [remotenav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([diagnosisnav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [diagnosisnav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([roadnav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [roadnav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([tracknav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [tracknav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    NSArray *viewarrays=@[remotenav,diagnosisnav,roadnav,tracknav];
    [self setViewControllers:viewarrays];
    [diagnosis release];
    [remote release];
    [road release];
    [track release];
    [diagnosisnav release];
    [remotenav release];
    [roadnav release];
    [tracknav release];
    [self createCustomTabBar];
	// Do any additional setup after loading the view.
}

-(void)createCustomTabBar
{
    for(int i=0;i<4;i++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i*80, 480.0-70.5+(iPhone5?88:0), 80.0, 70.5);
        btn.tag=i;
        [btn setExclusiveTouch:YES];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"safer_bt%d",i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"safer_bt%d_press",i]] forState:UIControlStateSelected];
        if(btn.tag==0)
        {
            [btn setSelected:YES];
        }
        btn.backgroundColor=[UIColor clearColor];
        [btn addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:btn];
        [self.view addSubview:btn];
    }
}

- (void)changeViewController:(UIButton *)button
{
    if(selectflag==button.tag)
    {
        return;
    }
    [self setBeforeButtoNormal:[buttons objectAtIndex:selectflag]];
    [self setCurrentButtonSelected:button];
    selectflag=button.tag;
    self.selectedIndex = button.tag;
}

#pragma mark-恢复上一个按钮的状态
-(void)setBeforeButtoNormal:(UIButton *)button
{
    [button setSelected:NO];
}

#pragma mark-选中当前的按钮的状态
-(void)setCurrentButtonSelected:(UIButton *)button
{
    [button setSelected:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [buttons release];
    buttons=nil;
    [super dealloc];
}

@end
