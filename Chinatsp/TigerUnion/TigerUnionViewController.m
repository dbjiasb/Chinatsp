//
//  TigerUnionViewController.m
//  Chinatsp
//
//  Created by yuante on 13-8-28.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "TigerUnionViewController.h"
#import "CarBlogViewController.h"
#import "ActivityViewController.h"
#import "FriendsViewController.h"
#import "ChatViewController.h"
@interface TigerUnionViewController ()

@end

@implementation TigerUnionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"虎翼联盟";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIBarButtonItem *leftBarBtn = [UIBarButtonItem buttonWithTitle:@"首页" imageName:@"btn_back_home" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    [self.navigationItem setCustomTitle:@"虎翼联盟"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    [self loadBG];
//    [self loadHeaderView];
    [self loadButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    navi.image = [UIImage imageNamed:@"union"];
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
    NSArray *nameArray = @[@"车博分享",@"组织活动",@"好友在图",@"即时通讯"];
    
    for (int i = 0; i < 4; i ++)
    {
        int x = i % 4;
        int y = i / 4;
        
        NSString *name = [NSString stringWithFormat:@"icon_tigerunion_%d",i + 1];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(17 + 75 * x, 25 + 105 * y, 60, 60)];
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
        { //车博分享
            CarBlogViewController *controller = [[CarBlogViewController alloc] init];
            
            [self.navigationController pushViewController:controller animated:YES];
            
            [controller release];
        }
            break;
        case 1:
        { //组织活动
            ActivityViewController *controller = [[ActivityViewController alloc] init];
            
            [self.navigationController pushViewController:controller animated:YES];
            
            [controller release];
        }
            break;
        case 2:
        {//好友在图
            FriendsViewController *controller = [[FriendsViewController alloc] init];
            
            [self.navigationController pushViewController:controller animated:YES];
            
            [controller release];
        }
            break;
        case 3:
        {//即时通讯
            ChatViewController *controller = [[ChatViewController alloc] init];
            
            [self.navigationController pushViewController:controller animated:YES];
            
            [controller release];
        }
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
