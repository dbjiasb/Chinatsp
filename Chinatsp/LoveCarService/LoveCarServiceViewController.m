//
//  LoveCarServiceViewController.m
//  Chinatsp
//
//  Created by yuante on 13-8-28.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "LoveCarServiceViewController.h"

@interface LoveCarServiceViewController ()

@end

@implementation LoveCarServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_scrollView release];
    _scrollView = nil;
    
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    [self loadBG];
    [self loadHeaderView];
    [self loadButtons];
}

- (void)loadBG
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, 320, [TSPUtils viewHeight] - 45)];
    bg.image = [UIImage imageNamed:@"bg_subviews"];
    [self.view addSubview:bg];
    [bg release];
}

- (void)loadHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    navi.image = [UIImage imageNamed:@"lovecar"];
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

- (void)loadButtons
{
    NSArray *nameArray = @[@"目的地查询",@"违章查询",@"汽车保险",@"车务代办",@"爱车常识",@"停车场信息",@"车辆代驾",@"天气预报",@"优惠信息"];
    
    for (int i = 0; i < 9; i ++)
    {
        int x = i % 4;
        int y = i / 4;
        
        NSString *name = [NSString stringWithFormat:@"icon_lovecar_%d",i + 1];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(17 + 75 * x, 80 + 105 * y, 60, 60)];
        button.tag = i;
        [button addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        NSString *string = [nameArray objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        label.center = CGPointMake(button.center.x, button.center.y + 43);
        label.text = string;
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        label.textColor = RGBCOLOR(42, 51, 59);
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
        
        
    }
    
}

- (void)btnPressed:(UIButton *)button
{
    switch (button.tag) {
        case 0:
            
            break;
            
        default:
            break;
    }
    
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
