//
//  GuideTabViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-15.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "GuideTabViewController.h"
#import "DestinationViewController.h"
#import "WeatherViewController.h"
#import "CloudViewController.h"
#import "config.h"

@interface GuideTabViewController ()

@end

@implementation GuideTabViewController

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
    DestinationViewController *destaination=[[DestinationViewController alloc] init];
    
    WeatherViewController *weather=[[WeatherViewController alloc] init];
    
    CloudViewController *cloud=[[CloudViewController alloc] init];
    
    UINavigationController *destainationnav=[[UINavigationController alloc] initWithRootViewController:destaination];
    UINavigationController *weathernav=[[UINavigationController alloc] initWithRootViewController:weather];
    UINavigationController *cloudnav=[[UINavigationController alloc] initWithRootViewController:cloud];
    
    if([destainationnav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [destainationnav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([weathernav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [weathernav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([cloudnav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [cloudnav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    NSArray *viewarrays=@[destainationnav,weathernav,cloudnav];
    [self setViewControllers:viewarrays];
    [destaination release];
    [weather release];
    [cloud release];
    [destainationnav release];
    [weathernav release];
    [cloudnav release];
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
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_btn%d",i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_btn%d_pressed",i]] forState:UIControlStateSelected];
        if(btn.tag==0)
        {
            [btn setSelected:YES];
        }
        btn.backgroundColor=[UIColor clearColor];
        if(btn.tag!=3)
        {
            [btn addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
        }
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
