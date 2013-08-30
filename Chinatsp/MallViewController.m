//
//  MallViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-17.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "MallViewController.h"
#import "config.h"

@interface MallViewController ()

@end

@implementation MallViewController

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
    [self initViews];
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    UIImageView *navbg=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    navbg.image=[UIImage imageNamed:@"mall_nav"];
    navbg.userInteractionEnabled=YES;
    [self.view addSubview:navbg];
    [navbg release];
    
    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame=CGRectMake(5.0, (45.0-35.0)/2, 47.5, 35.0);
    [backbtn setImage:[UIImage imageNamed:@"exit_btn"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navbg addSubview:backbtn];
    
    UIImageView *bgview=[[UIImageView alloc] initWithFrame:CGRectMake(0.0,460.0-365.0, 320.0, 365.0+(iPhone5?88:0))];
    bgview.image=[UIImage imageNamed:@"home_bg"];
    [self.view addSubview:bgview];
    [bgview release];
    
    UIImageView *mallimg=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 163.5)];
    mallimg.image=[UIImage imageNamed:@"mall_img"];
    [self.view addSubview:mallimg];
    [mallimg release];
    
    UIButton *servicebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    servicebtn.frame=CGRectMake(10.0, mallimg.frame.origin.y+mallimg.frame.size.height+10.0, 60.0, 60.0);
    [servicebtn setImage:[UIImage imageNamed:@"service_icon"] forState:UIControlStateNormal];
    [self.view addSubview:servicebtn];
    
    UIButton *mapbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    mapbtn.frame=CGRectMake(servicebtn.frame.size.width+servicebtn.frame.origin.x+10, mallimg.frame.origin.y+mallimg.frame.size.height+10.0, 60.0, 60.0);
    [mapbtn setImage:[UIImage imageNamed:@"map_grade"] forState:UIControlStateNormal];
    [self.view addSubview:mapbtn];
}

-(void)btnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
