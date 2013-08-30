//
//  RemoteControlViewController.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-26.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#define UnLockDoorTag 101
#define LockDoorTag 102
#define ShowCarLocationTag 103
#define AirConditionalTag 105
#define OpenWindowTag 106
#define CloseWindowTag 107
#define OpenEngineTag 108
#define CloseEngineTag 109
#define OpenAirTag 110
#define CloseAirTag 111

#import "RemoteControlViewController.h"
#import "UIHelper.h"
#import "NetService.h"
#import "JSONKit.h"
#import "config.h"

@interface RemoteControlViewController ()

@end

@implementation RemoteControlViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"远程控制";
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initButtons];
	// Do any additional setup after loading the view.
}

-(void)initButtons
{
    UIView *remotebg=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 345.5+(iPhone5?88:0))];
    remotebg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    [self.view addSubview:remotebg];
    [remotebg release];
    
    UIScrollView *scoll=[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0-44.0-70.5+(iPhone5?88:0))];
    
    UIButton *unLockDoor=[UIButton buttonWithType:UIButtonTypeCustom];
    unLockDoor.frame=CGRectMake(7.5, 5.0, 152.5,75.5);
    unLockDoor.tag=UnLockDoorTag;
    [unLockDoor setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
    [unLockDoor addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scoll addSubview:unLockDoor];

    UIButton *lockDoor=[UIButton buttonWithType:UIButtonTypeCustom];
    lockDoor.tag=LockDoorTag;
    lockDoor.frame=CGRectMake(unLockDoor.frame.size.width+unLockDoor.frame.origin.x, 5.0, 152.5, 75.5);
    [lockDoor setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
    [lockDoor addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scoll addSubview:lockDoor];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake((304.5-80.0)/2, lockDoor.frame.size.height+lockDoor.frame.origin.y+10.0, 80.0, 25.0)];
    label.text=@"功能介绍";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [scoll addSubview:label];
    [label release];
    
    UIButton *openair=[UIButton buttonWithType:UIButtonTypeCustom];
    openair.tag=OpenAirTag;
    [openair addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    openair.frame=CGRectMake(7.5,label.frame.size.height+label.frame.origin.y+10.0, 152.5, 75.5);
    [openair setImage:[UIImage imageNamed:@"open_air"] forState:UIControlStateNormal];
    [scoll addSubview:openair];
    
    UIButton *closeair=[UIButton buttonWithType:UIButtonTypeCustom];
    closeair.tag=CloseAirTag;
    [closeair addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    closeair.frame=CGRectMake(openair.frame.origin.x+openair.frame.size.width,label.frame.size.height+label.frame.origin.y+10.0, 152.5, 75.5);
    [closeair setImage:[UIImage imageNamed:@"close_air"] forState:UIControlStateNormal];
    [scoll addSubview:closeair];
    
    UILabel *label4=[[UILabel alloc] initWithFrame:CGRectMake((304.5-80.0)/2, openair.frame.size.height+openair.frame.origin.y+10.0, 80.0, 25.0)];
    label4.text=@"功能介绍";
    label4.textColor=[UIColor whiteColor];
    label4.backgroundColor=[UIColor clearColor];
    [scoll addSubview:label4];
    [label4 release];
    
    UIButton *showCarLocation=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    showCarLocation.tag=ShowCarLocationTag;
    [showCarLocation addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    showCarLocation.frame=CGRectMake((320.0-304.5)/2,label4.frame.size.height+label4.frame.origin.y+10.0, 304.5, 70.5);
    [showCarLocation setImage:[UIImage imageNamed:@"car_location"] forState:UIControlStateNormal];
    [scoll addSubview:showCarLocation];
    
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake((304.5-80.0)/2, showCarLocation.frame.size.height+showCarLocation.frame.origin.y+10.0, 80.0, 25.0)];
    label2.text=@"功能介绍";
    label2.textColor=[UIColor whiteColor];
    label2.backgroundColor=[UIColor clearColor];
    [scoll addSubview:label2];
    [label2 release];
    
    UIButton *openwindow=[UIButton buttonWithType:UIButtonTypeCustom];
    openwindow.tag=OpenWindowTag;
    [openwindow addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    openwindow.frame=CGRectMake(7.5,label2.frame.size.height+label2.frame.origin.y+10.0, 152.5, 75.5);
    [openwindow setImage:[UIImage imageNamed:@"open_window"] forState:UIControlStateNormal];
    [scoll addSubview:openwindow];
    
    UIButton *closewindow=[UIButton buttonWithType:UIButtonTypeCustom];
    closewindow.tag=CloseWindowTag;
    [closewindow addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    closewindow.frame=CGRectMake(openwindow.frame.origin.x+openwindow.frame.size.width,label2.frame.size.height+label2.frame.origin.y+10.0, 152.5, 75.5);
    [closewindow setImage:[UIImage imageNamed:@"close_window"] forState:UIControlStateNormal];
    [scoll addSubview:closewindow];
    
    UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake((304.5-80.0)/2, openwindow.frame.size.height+openwindow.frame.origin.y+10.0, 80.0, 25.0)];
    label3.text=@"功能介绍";
    label3.textColor=[UIColor whiteColor];
    label3.backgroundColor=[UIColor clearColor];
    [scoll addSubview:label3];
    [label3 release];
    
//    UIButton *openengine=[UIButton buttonWithType:UIButtonTypeCustom];
//    openengine.tag=OpenEngineTag;
//    [openengine addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    openengine.frame=CGRectMake(7.5,label3.frame.size.height+label3.frame.origin.y+10.0, 152.5, 75.5);
//    [openengine setImage:[UIImage imageNamed:@"open_engine"] forState:UIControlStateNormal];
//    [scoll addSubview:openengine];
//    
//    UIButton *closeengine=[UIButton buttonWithType:UIButtonTypeCustom];
//    closeengine.tag=CloseEngineTag;
//    [closeengine addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    closeengine.frame=CGRectMake(openengine.frame.origin.x+openengine.frame.size.width,label3.frame.size.height+label3.frame.origin.y+10.0, 152.5, 75.5);
//    [closeengine setImage:[UIImage imageNamed:@"close_engine"] forState:UIControlStateNormal];
//    [scoll addSubview:closeengine];
//    
//    UILabel *label4=[[UILabel alloc] initWithFrame:CGRectMake((304.5-80.0)/2, openengine.frame.size.height+openengine.frame.origin.y+10.0, 80.0, 25.0)];
//    label4.text=@"功能介绍";
//    label4.textColor=[UIColor whiteColor];
//    label4.backgroundColor=[UIColor clearColor];
//    [scoll addSubview:label4];
//    [label4 release];
    
    [scoll setContentSize:CGSizeMake(320.0, label3.frame.size.height+label3.frame.origin.y)];
    [self.view addSubview:scoll];
    [scoll release];
}

-(void)btnClick:(id)sender
{
    UIButton *button=(UIButton *)sender;
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(sendCarCammendThread:) toTarget:self withObject:[NSNumber numberWithInt:button.tag]];
}

-(void)sendCarCammendThread:(NSNumber *)num
{
    NSData *data=[[NetService singleHttpService] sendCommantBywake:WAKE];
    if(data)
    {
        if([[[data objectFromJSONData] objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            if([num intValue]==UnLockDoorTag)
            {
                data=[[NetService singleHttpService] sendCommantBystatus:@"OPEN-DOOR"];
                [self performSelectorOnMainThread:@selector(getResultByOpenDoor:) withObject:data waitUntilDone:NO];
            }
            else if([num intValue]==LockDoorTag)
            {
                data=[[NetService singleHttpService] sendCommantBystatus:@"CLOSE-DOOR"];
                [self performSelectorOnMainThread:@selector(getResultByCloseDoor:) withObject:data waitUntilDone:NO];
            }
            else if ([num intValue]==ShowCarLocationTag)
            {
                data=[[NetService singleHttpService] sendCommantBystatus:@"SEEK-CAR"];
                [self performSelectorOnMainThread:@selector(getResultByShowCarLocation:) withObject:data waitUntilDone:NO];
            }
            else if ([num intValue]==OpenWindowTag)
            {
                data=[[NetService singleHttpService] sendCommantBystatus:@"OPEN-WINDOW"];
                [self performSelectorOnMainThread:@selector(getResultByOpenWindow:) withObject:data waitUntilDone:NO];
            }
            else if ([num intValue]==CloseWindowTag)
            {
                data=[[NetService singleHttpService] sendCommantBystatus:@"CLOSE-WINDOW"];
                [self performSelectorOnMainThread:@selector(getResultByCloseWindow:) withObject:data waitUntilDone:NO];
            }
            else if ([num intValue]==OpenAirTag)
            {
                data=[[NetService singleHttpService] sendCommantBystatus:@"OPEN-AIR-CONDITIONING"];
                [self performSelectorOnMainThread:@selector(getResultByOpenAir:) withObject:data waitUntilDone:NO];
            }
            else if ([num intValue]==CloseAirTag)
            {
                data=[[NetService singleHttpService] sendCommantBystatus:@"CLOSE-AIR-CONDITIONING"];
                [self performSelectorOnMainThread:@selector(getResultByCloseAir:) withObject:data waitUntilDone:NO];
            }
        }
        else
        {
            [self performSelectorOnMainThread:@selector(getFail:) withObject:@"唤醒失败" waitUntilDone:NO];
        }
    }else
    {
        [self performSelectorOnMainThread:@selector(getFail:) withObject:@"网络异常" waitUntilDone:NO];
    }
}

-(void)btnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)getFail:(NSString *)str
{
    [self closeProgressDialog];
    [UIHelper showAlertview:str];
}

-(void)getResultByOpenDoor:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            [UIHelper showAlertview:@"打开车门命令下发成功!"];
        }
        else
        {
            [UIHelper showAlertview:@"打开车门命令下发失败!"];
        }
    }
    else
    {
        [UIHelper showAlertview:@"网络异常!"];
    }
}

-(void)getResultByCloseDoor:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            [UIHelper showAlertview:@"关闭车门命令下发成功!"];
        }
        else
        {
            [UIHelper showAlertview:@"关闭车门命令下发失败!"];
        }
    }
    else
    {
        [UIHelper showAlertview:@"网络异常!"];
    }
}

-(void)getResultByShowCarLocation:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            [UIHelper showAlertview:@"双闪鸣笛命令下发成功!"];
        }
        else
        {
            [UIHelper showAlertview:@"双闪鸣笛命令下发失败!"];
        }
    }
    else
    {
        [UIHelper showAlertview:@"网络异常!"];
    }
}

-(void)getResultByOpenWindow:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            [UIHelper showAlertview:@"打开车窗命令下发成功!"];
        }
        else
        {
            [UIHelper showAlertview:@"打开车窗命令下发失败!"];
        }
    }
    else
    {
        [UIHelper showAlertview:@"网络异常!"];
    }
}

-(void)getResultByCloseWindow:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            [UIHelper showAlertview:@"关闭车窗命令下发成功!"];
        }
        else
        {
            [UIHelper showAlertview:@"关闭车窗命令下发失败!"];
        }
    }
    else
    {
        [UIHelper showAlertview:@"网络异常!"];
    }
}

-(void)getResultByOpenAir:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            [UIHelper showAlertview:@"打开空调命令下发成功!"];
        }
        else
        {
            [UIHelper showAlertview:@"打开空调命令下发失败!"];
        }
    }
    else
    {
        [UIHelper showAlertview:@"网络异常!"];
    }
}

-(void)getResultByCloseAir:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            [UIHelper showAlertview:@"关闭空调命令下发成功!"];
        }
        else
        {
            [UIHelper showAlertview:@"关闭空调命令下发失败!"];
        }
    }
    else
    {
        [UIHelper showAlertview:@"网络异常!"];
    }
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0-70.5-44.0+(iPhone5?88:0))];
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

-(void)dealloc
{
    [super dealloc];
}

@end
