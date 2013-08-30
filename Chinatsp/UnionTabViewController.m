//
//  UnionTabViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-17.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "UnionTabViewController.h"
#import "CarBlogViewController.h"
#import "ActivityViewController.h"
#import "ChatViewController.h"
#import "CarFriendViewController.h"
#import "config.h"

@interface UnionTabViewController ()

@end

@implementation UnionTabViewController

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
    CarBlogViewController *carblog=[[CarBlogViewController alloc] init];
    ActivityViewController *activity=[[ActivityViewController alloc] init];
    ChatViewController *chat=[[ChatViewController alloc] init];
    CarFriendViewController *carfriend=[[CarFriendViewController alloc] init];
    UINavigationController *carblognav=[[UINavigationController alloc] initWithRootViewController:carblog];
    UINavigationController *activtynav=[[UINavigationController alloc] initWithRootViewController:activity];
    UINavigationController *chatnav=[[UINavigationController alloc] initWithRootViewController:chat];
    UINavigationController *carfriendnav=[[UINavigationController alloc] initWithRootViewController:carfriend];
    if([carblognav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [carblognav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([chatnav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [chatnav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([carfriendnav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [carfriendnav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([activtynav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [activtynav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    NSArray *viewarrays=@[carblognav,activtynav,chatnav,carfriendnav];
    [self setViewControllers:viewarrays];
    [carblog release];
    [activity release];
    [chat release];
    [carfriend release];
    [carblognav release];
    [activtynav release];
    [chatnav release];
    [carfriendnav release];
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
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"union_bt%d",i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"union_bt%d_press",i]] forState:UIControlStateSelected];
        if(btn.tag==0)
        {
            [btn setSelected:YES];
        }
        btn.backgroundColor=[UIColor clearColor];
        if(btn.tag!=2&&btn.tag!=3)
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
