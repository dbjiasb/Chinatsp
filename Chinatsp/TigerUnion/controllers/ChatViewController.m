//
//  ChatViewController.m
//  Chinatsp
//
//  Created by Dragon on 13-9-2.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

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
    
    UIBarButtonItem *leftBarBtn = [UIBarButtonItem buttonWithTitle:@"返回" imageName:@"btn_back_home" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    [self.navigationItem setCustomTitle:@"即时通讯"];
    
    [self loadBG];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadBG
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [MyUtil viewHeight])];
    bg.image = [UIImage imageNamed:@"bg_subviews"];
    [self.view addSubview:bg];
    [bg release];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
