//
//  SecTabViewControllViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-14.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "SecTabViewControll.h"
#import "CarBeautyViewController.h"
#import "CommentViewController.h"
#import "CarStoreListViewController.h"
#import "IllegalViewController.h"
#import "config.h"

@interface SecTabViewControll ()

@end

@implementation SecTabViewControll

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
    IllegalViewController *illegal=[[IllegalViewController alloc] init];
    
    CarStoreListViewController *stores=[[CarStoreListViewController alloc] init];
    
    CarBeautyViewController *beauty=[[CarBeautyViewController alloc] init];
    
    CommentViewController *comment=[[CommentViewController alloc] init];
    UINavigationController *violationNav=[[UINavigationController alloc] initWithRootViewController:illegal];
    UINavigationController *storesNav=[[UINavigationController alloc] initWithRootViewController:stores];
    UINavigationController *beautyNav=[[UINavigationController alloc] initWithRootViewController:beauty];
    UINavigationController *commentNav=[[UINavigationController alloc] initWithRootViewController:comment];
    if([violationNav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [violationNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([storesNav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [storesNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([beautyNav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [beautyNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    if([commentNav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [commentNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    NSArray *viewarrays=@[violationNav,storesNav,commentNav,beautyNav];
    [self setViewControllers:viewarrays];
    [illegal release];
    [stores release];
    [beauty release];
    [comment release];
    [violationNav release];
    [storesNav release];
    [beautyNav release];
    [commentNav release];
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
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sec_bt%d",i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sec_bt%d_press",i]] forState:UIControlStateSelected];
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
