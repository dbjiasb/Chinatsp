//
//  BreakRulesViewController.m
//  Chinatsp
//
//  Created by yuante on 13-8-28.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "BreakRulesViewController.h"

@interface BreakRulesViewController ()

@end

@implementation BreakRulesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadBG];
    [self loadHeaderView];
    [self loadContentView];

    
//    UIImageView *imgv =[[UIImageView alloc] initWithFrame:CGRectMake(0, 48, 320, [TSPUtils viewHeight] - 48)];
//    imgv.image = [UIImage imageNamed:@"demoimg.jpg"];
//    
//    [self.view addSubview:imgv];
//    [imgv release];
    
}

- (void)loadHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    navi.image = [UIImage imageNamed:@"park"];
    [self.view addSubview:navi];
    [navi release];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(4, 4, 60, 38)];
    [leftBtn setImage:[UIImage imageNamed:@"btn_back_home"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:leftBtn];
    
    [self.view addSubview:header];
    
    [header release];
}

- (void)loadBG
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, 320, [MyUtil viewHeight] - 45)];
    bg.image = [UIImage imageNamed:@"bg_subviews"];
    [self.view addSubview:bg];
    [bg release];
}

- (void)loadContentView
{
    
    UIImageView *bg_up = [[UIImageView alloc] initWithFrame:CGRectMake(5, 53, 310, 108)];
    bg_up.image = [[UIImage imageNamed:@"fenlan-ios"] stretchableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.view addSubview:bg_up];
    [bg_up release];
    
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [firstBtn setFrame:CGRectMake(20, 68, 128, 74)];
    [firstBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.view addSubview:firstBtn];
    
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [secondBtn setFrame:CGRectMake(173, 68, 128, 74)];
    [secondBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.view addSubview:secondBtn];
    
    float offSetY = 0;
    if ([MyUtil isIphone5]) {
        offSetY = 70;
    }
    
    UIImageView *bg_down = [[UIImageView alloc] initWithFrame:CGRectMake(5, 170, 310, 285 + offSetY)];
    bg_down.image = [[UIImage imageNamed:@"fenlan-ios"] stretchableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.view addSubview:bg_down];
    [bg_down release];
    
    
}

- (void)back
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
