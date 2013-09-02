//
//  MyCarInViewController.m
//  Chinatsp
//
//  Created by yuante on 13-8-28.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "MyCarInViewController.h"
#import "RemoteCheckViewController.h"

@interface MyCarInViewController ()

@end

@implementation MyCarInViewController

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
    UIBarButtonItem *leftBarBtn = [UIBarButtonItem buttonWithTitle:@"首页" imageName:@"btn_back_home1" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    [self.navigationItem setCustomTitle:@"我的车载"];

    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    [self loadBG];
//    [self loadHeaderView];
    [self loadButtons];
}

- (void)loadBG
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [MyUtil viewHeight])];
    bg.image = [UIImage imageNamed:@"bg_subviews"];
    [self.view addSubview:bg];
    [bg release];
}

- (void)loadHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    navi.image = [UIImage imageNamed:@"mycarin"];
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
    NSArray *nameArray = @[@"车况查询",@"远程诊断",@"道路救援",@"被盗追踪",@"保养预约",@"绑定车机",@"修改PIN码"];
    
    for (int i = 0; i < [nameArray count]; i ++)
    {
        int x = i % 4;
        int y = i / 4;
        
        NSString *name = [NSString stringWithFormat:@"icon_mycarin_%d",i + 1];
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
        case 1:
        {//远程诊断
            RemoteCheckViewController *controller = [[RemoteCheckViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            
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
