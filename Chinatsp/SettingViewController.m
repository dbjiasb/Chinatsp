//
//  SettingViewController.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//
#define UserInfoTag 101
#define CarInfoTag 102
#define AboutSoftTag 103
#define CheckSoftTag 104
#define RecommendFriendTag 105
#define LogoutTag 106

#import "SettingViewController.h"
#import "MyDefaults.h"
#import "LoginViewController.h"
#import "NetService.h"
#import "UIHelper.h"
#import "UserInfoViewController.h"
#import "CarInfoViewController.h"
#import "AboutViewController.h"
#import "JSONKit.h"
#import "config.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"更多";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarBtn = [UIBarButtonItem buttonWithTitle:@"首页" imageName:@"btn_back_home" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    [self.navigationItem setCustomTitle:@"更多"];

    [self loadBG];
    [self initViews];
	// Do any additional setup after loading the view.
}

- (void)loadBG
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [MyUtil viewHeight])];
    bg.image = [UIImage imageNamed:@"bg_subviews"];
    [self.view addSubview:bg];
    [bg release];
}

-(void)initViews
{    
    UIButton *userInfo=[UIButton buttonWithType:UIButtonTypeCustom];
    userInfo.frame=CGRectMake((320.0-288.5)/2, 10.0f, 288.0, 42.5);
    userInfo.tag=UserInfoTag;
    [userInfo addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [userInfo setBackgroundImage:[UIImage imageNamed:@"more_btn_01"] forState:UIControlStateNormal];
    [userInfo setTitle:@"个人信息" forState:UIControlStateNormal];
    [userInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:userInfo];
    
    UIButton *carInfo=[UIButton buttonWithType:UIButtonTypeCustom];
    carInfo.frame=CGRectMake((320.0-288.5)/2,userInfo.frame.origin.y + userInfo.frame.size.height+10, 288.0, 42.5);
    carInfo.tag=CarInfoTag;
    [carInfo addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [carInfo setBackgroundImage:[UIImage imageNamed:@"more_btn_01"] forState:UIControlStateNormal];
    [carInfo setTitle:@"车辆信息" forState:UIControlStateNormal];
    [carInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:carInfo];
    
    UIButton *aboutSoft=[UIButton buttonWithType:UIButtonTypeCustom];
    [aboutSoft addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    aboutSoft.frame=CGRectMake((320.0-288.5)/2,carInfo.frame.origin.y + carInfo.frame.size.height+10, 288.0, 42.5);
    aboutSoft.tag=AboutSoftTag;
    [aboutSoft setBackgroundImage:[UIImage imageNamed:@"more_btn_01"] forState:UIControlStateNormal];
    [aboutSoft setTitle:@"关于软件" forState:UIControlStateNormal];
    [aboutSoft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:aboutSoft];
    
    UIButton *softupgrade=[UIButton buttonWithType:UIButtonTypeCustom];
    softupgrade.frame=CGRectMake((320.0-288.5)/2, aboutSoft.frame.origin.y + aboutSoft.frame.size.height +10, 288.0,42.5);
    softupgrade.tag=CheckSoftTag;
    [softupgrade addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [softupgrade setBackgroundImage:[UIImage imageNamed:@"more_btn_01"] forState:UIControlStateNormal];
    [softupgrade setTitle:@"软件升级" forState:UIControlStateNormal];
    [softupgrade setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:softupgrade];
    
    UIButton *recFriend=[UIButton buttonWithType:UIButtonTypeCustom];
    recFriend.frame=CGRectMake((320.0-288.5)/2, softupgrade.frame.origin.y + softupgrade.frame.size.height +10, 288.0, 42.5);
    recFriend.tag=RecommendFriendTag;
    [recFriend addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [recFriend setBackgroundImage:[UIImage imageNamed:@"more_btn_01"] forState:UIControlStateNormal];
    [recFriend setTitle:@"推荐好友" forState:UIControlStateNormal];
    [recFriend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:recFriend];
    
    UIButton *logout=[UIButton buttonWithType:UIButtonTypeCustom];
    logout.frame=CGRectMake((320.0-288.5)/2, recFriend.frame.origin.y + recFriend.frame.size.height +10, 288.0,42.5);
    logout.tag=LogoutTag;
    [logout addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [logout setBackgroundImage:[UIImage imageNamed:@"more_btn_01"] forState:UIControlStateNormal];
    [logout setTitle:@"注销" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:logout];
}

- (void)back
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)exit
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)buttonClick:(id)sender
{
    UIButton *button=(UIButton *)sender;
    if(button.tag==LogoutTag)
    {
//        [self createProgressDialog];
//        [NSThread detachNewThreadSelector:@selector(logoutInThread) toTarget:self withObject:nil];
        [MyDefaults setUserName:nil];
        [MyDefaults setPwd:nil];
        [MyDefaults setTuid:nil];
        [MyDefaults setToken:nil];
        [self dismissModalViewControllerAnimated:YES];
        [UIHelper showAlertview:@"注销成功!"];
        
    }else if (button.tag==UserInfoTag)
    {
        UserInfoViewController *userinfo=[[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:userinfo animated:YES];
        [userinfo release];
    }
    else if (button.tag==CarInfoTag)
    {
        CarInfoViewController *carinfo=[[CarInfoViewController alloc] init];
        [self.navigationController pushViewController:carinfo animated:YES];
        [carinfo release];
    }else if (button.tag==AboutSoftTag)
    {
        AboutViewController *about=[[AboutViewController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
        [about release];
    }
    else if (button.tag==RecommendFriendTag)
    {
        Class messageClass=(NSClassFromString(@"MFMessageComposeViewController"));
        if(messageClass)
        {
            if([MFMessageComposeViewController canSendText])
            {
                MFMessageComposeViewController *picker=[[[MFMessageComposeViewController alloc] init] autorelease];
                picker.body=@"http://tsp1.incall.cn/apk/ChinaTspCar.apk";
                picker.messageComposeDelegate=self;
                [self presentModalViewController:picker animated:YES];
            }
            else
            {
                [UIHelper showAlertview:@"设备没有短信功能"];
            }
        }
        else
        {
            [UIHelper showAlertview:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
        }
    }else if (button.tag==CheckSoftTag)
    {
        [UIHelper showAlertview:@"目前没有新版本"];
    }
}

-(void)logoutInThread
{
    NSData *data=[[NetService singleHttpService] logout:[UIHelper getOpenUDID]];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        [self performSelectorOnMainThread:@selector(getResult:) withObject:nd waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(getFailResult) withObject:nil waitUntilDone:NO];
    }
}

-(void)getResult:(NSDictionary *)nd
{
    NSLog(@"=========%@",nd);
    [self closeProgressDialog];
    if([@"OK" isEqualToString:[nd objectForKey:@"resp_status"]])
    {
        [MyDefaults setUserName:nil];
        [MyDefaults setPwd:nil];
        [MyDefaults setTuid:nil];
        [MyDefaults setToken:nil];
        [self dismissModalViewControllerAnimated:YES];
        [UIHelper showAlertview:@"注销成功!"];
    }
}

-(void)getFailResult
{
    [self closeProgressDialog];
    [UIHelper showAlertview:@"注销失败！"];
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 416.0+(iPhone5?88:0))];
    bgview.backgroundColor=[UIColor blackColor];
    bgview.alpha=0.7;
    [self.view addSubview:bgview];
    [bgview release];
    
    if (progressdialog) {
        [progressdialog stopAnimating];
        [progressdialog removeFromSuperview];
        progressdialog = nil;
    }
    progressdialog = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    progressdialog.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
    progressdialog.center = bgview.center;
    [bgview addSubview:progressdialog];
    [progressdialog release];
    
    [progressdialog startAnimating];
}

-(void)closeProgressDialog
{
    if (progressdialog) {
        [progressdialog stopAnimating];
        [progressdialog.superview removeFromSuperview];
        progressdialog = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
