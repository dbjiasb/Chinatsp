//
//  HomeViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-11.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#define MoreTag 115
#define RefreshTag 116

#import "HomeViewController.h"
#import "DDProgressView.h"
#import "NetService.h"
#import "MyDefaults.h"
#import "LoginViewController.h"
#import "JSONKit.h"
#import "UIHelper.h"
#import "SettingViewController.h"
#import "ChinaTspDao.h"
#import "SaferTabViewController.h"
#import "SecTabViewControll.h"
#import "GuideTabViewController.h"
#import "MallViewController.h"
#import "UnionTabViewController.h"
#import "CarStatus.h"
#import "config.h"

#import "OBShapedButton.h"
#import "SCGIFImageView.h"
#import "LoveCarServiceViewController.h"
#import "TigerUnionViewController.h"
#import "CarShopViewController.h"
#import "MyCarInViewController.h"
#import "SettingViewController.h"

#import "WashingCarViewController.h"
#import "AddOilViewController.h"
#import "ParkingViewController.h"
#import "BreakRulesViewController.h"


@interface HomeViewController ()
{
    
    int _countForCircleView;
    BOOL _isAnimating;
}
@end

@implementation HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _countForCircleView = 0;
        _isAnimating = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [self loadNewView];
    [self loadChangeBtn];
    
    //旧界面
//    [self initViews];
    
//    CarStatus *carstatus=[[ChinaTspDao singleDao] LoadCarInfo];
//    if(carstatus)
//    {
//        [self initCarStatus:carstatus];
//    }
	// Do any additional setup after loading the view.
}

- (void)loadNewView
{
    float offsetY = 0;

    UIImageView *homeBg=[[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [MyUtil viewHeight])] autorelease];
    if ([MyUtil isIphone5])
    {
        homeBg.image=[UIImage imageNamed:@"bg-shouye_560h"];
        offsetY = 50;
    }
    else
    {
        homeBg.image=[UIImage imageNamed:@"bg_home"];
    }

    [self.view addSubview:homeBg];
    
    
    UIImage *img1 = [UIImage imageNamed:@"l_u_n"];
    OBShapedButton *left_up_btn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
    left_up_btn.tag = 6;
    [left_up_btn setFrame:CGRectMake(17, 200 + offsetY, img1.size.width/2 * 1.3 , img1.size.height / 2 * 1.3)];
    [left_up_btn setImage:img1 forState:UIControlStateNormal];
    [self.view addSubview:left_up_btn];
    [left_up_btn addTarget:self action:@selector(loadViewWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img2 = [UIImage imageNamed:@"r_u_n"];
    OBShapedButton *right_up_btn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
    right_up_btn.tag = 7;
    [right_up_btn setFrame:CGRectMake(165, 200 + offsetY, img1.size.width/2 * 1.3, img1.size.height / 2 * 1.3)];
    [right_up_btn setImage:img2 forState:UIControlStateNormal];
    [self.view addSubview:right_up_btn];
    [right_up_btn addTarget:self action:@selector(loadViewWithButton:) forControlEvents:UIControlEventTouchUpInside];

    UIImage *img3 = [UIImage imageNamed:@"r_d_n"];
    OBShapedButton *right_down_btn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
    right_down_btn.tag = 8;
    [right_down_btn setFrame:CGRectMake(165, 315 + offsetY, img1.size.width/2 * 1.3, img1.size.height / 2 * 1.3)];
    [right_down_btn setImage:img3 forState:UIControlStateNormal];
    [self.view addSubview:right_down_btn];
    [right_down_btn addTarget:self action:@selector(loadViewWithButton:) forControlEvents:UIControlEventTouchUpInside];

    UIImage *img4 = [UIImage imageNamed:@"l_d_n"];
    OBShapedButton *left_down_btn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
    left_down_btn.tag = 9;
    [left_down_btn setFrame:CGRectMake(17, 315 + offsetY, img1.size.width/2 * 1.3, img1.size.height / 2 * 1.3)];
    [left_down_btn setImage:img4 forState:UIControlStateNormal];
    [self.view addSubview:left_down_btn];
    [left_down_btn addTarget:self action:@selector(loadViewWithButton:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)loadChangeBtn
{
    float offsetY = 0;

    if([MyUtil isIphone5])
    {
        offsetY = 50;
    }
    homeNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeNaviBtn setFrame:CGRectMake(125, 277 + offsetY, 70, 70)];
    [homeNaviBtn setImage:[UIImage imageNamed:@"anniu_00000"] forState:UIControlStateNormal];
    [self.view addSubview:homeNaviBtn];
    [homeNaviBtn addTarget:self action:@selector(manageCircleView) forControlEvents:UIControlEventTouchUpInside];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changImage) userInfo:nil repeats:YES];
}

//timer method 
- (void)changImage
{
    static int count = 0;
    NSString *str = [NSString stringWithFormat:@"anniu_%05d",++count];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:str ofType:@"png"]];
    [homeNaviBtn setImage:image forState:UIControlStateNormal];
    
    if (count == 47) {
        count = 0;
    }
}

- (void)loadGifImages
{
    
    SCGIFImageView *gifImageView = [[[SCGIFImageView alloc] initWithFrame:CGRectMake(130, 230, 80, 80)] autorelease];
    gifImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gifImageView.backgroundColor	= [UIColor clearColor];
    gifImageView.contentMode		= UIViewContentModeScaleAspectFit;
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"maninwater.gif" ofType:nil];
    NSData* imageData = [NSData dataWithContentsOfFile:filePath];
    [gifImageView setData:imageData];

    [self.view addSubview:gifImageView];
}

- (void)manageCircleView
{
    if (_isAnimating) {
        return;
    }
    
    if (circleView) {
        [self hideCircleView];
    }
    else
    {
        [self showCircleView];
    }
}

- (void)hideCircleView
{
    _isAnimating = YES;
    
    for (UIView *view in circleView.subviews) {
        [view removeFromSuperview];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(changCircleViewImageBack:) userInfo:nil repeats:YES];

}

- (void)showCircleView
{
    _isAnimating = YES;
    
    float offsetY = 0;
    
    if([MyUtil isIphone5])
    {
        offsetY = 50;
    }

    circleView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 172 + offsetY, 273, 273)];
    circleView.image = [UIImage imageNamed:@"tanchu_00000"];
    circleView.userInteractionEnabled = YES;
//    [self.view addSubview:circleView];
    [self.view insertSubview:circleView belowSubview:homeNaviBtn];
    [circleView release];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(changCircleViewImageForward:) userInfo:nil repeats:YES];

}

- (void)loadButtonsOnCircleView
{
    float sizeX = 59;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag = 1;
    [button1 setFrame:CGRectMake(25, 148, sizeX, sizeX)];
    [button1 setImage:[UIImage imageNamed:@"btn_1"] forState:UIControlStateNormal];
    [circleView addSubview:button1];
    [button1 addTarget:self action:@selector(loadViewWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 2;
    [button2 setFrame:CGRectMake(25,63, sizeX, sizeX)];
    [button2 setImage:[UIImage imageNamed:@"btn_2"] forState:UIControlStateNormal];
    [circleView addSubview:button2];
    [button2 addTarget:self action:@selector(loadViewWithButton:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.tag = 3;
    [button3 setFrame:CGRectMake(108, 13, sizeX, sizeX)];
    [button3 setImage:[UIImage imageNamed:@"btn_3"] forState:UIControlStateNormal];
    [circleView addSubview:button3];
    [button3 addTarget:self action:@selector(loadViewWithButton:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.tag = 4;
    [button4 setFrame:CGRectMake(189, 60, sizeX, sizeX)];
    [button4 setImage:[UIImage imageNamed:@"btn_4"] forState:UIControlStateNormal];
    [circleView addSubview:button4];
    [button4 addTarget:self action:@selector(loadViewWithButton:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    button5.tag = 5;
    [button5 setFrame:CGRectMake(189, 148, sizeX, sizeX)];
    [button5 setImage:[UIImage imageNamed:@"btn_5"] forState:UIControlStateNormal];
    [circleView addSubview:button5];
    [button5 addTarget:self action:@selector(loadViewWithButton:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)loadViewWithButton:(UIButton *)button
{
    switch (button.tag) {
        case 1:
        {//虎翼联盟

            TigerUnionViewController *controller = [[TigerUnionViewController alloc] init];
            UINavigationController *naivController = [[UINavigationController alloc] initWithRootViewController:controller];
//            naivController.navigationBarHidden = YES;

            [self presentViewController:naivController animated:YES completion:^{
                
                [self hideCircleView];
                
                UIView *imgv = [self.view viewWithTag:1016];
                imgv.alpha = 1;
                [UIView animateWithDuration:0.2 animations:^{
                    imgv.alpha = 0;
                } completion:^(BOOL finished) {
                    [imgv removeFromSuperview];
                }];
            }];
            [controller release];
            [naivController release];
        }
            break;
        case 2:
        {//爱车服务
            
            LoveCarServiceViewController *controller = [[LoveCarServiceViewController alloc] init];
            UINavigationController *naivController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:naivController animated:YES completion:^{
                
                [self hideCircleView];
                
                UIView *imgv = [self.view viewWithTag:1016];
                imgv.alpha = 1;
                [UIView animateWithDuration:0.2 animations:^{
                    imgv.alpha = 0;
                } completion:^(BOOL finished) {
                    [imgv removeFromSuperview];
                }];
            }];
            [controller release];
            [naivController release];
        }
            break;
        case 3:
        {//我的车载
            MyCarInViewController *controller = [[MyCarInViewController alloc] init];
            UINavigationController *naivController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:naivController animated:YES completion:^{
                
                [self hideCircleView];
                
                UIView *imgv = [self.view viewWithTag:1016];
                imgv.alpha = 1;
                [UIView animateWithDuration:0.2 animations:^{
                    imgv.alpha = 0;
                } completion:^(BOOL finished) {
                    [imgv removeFromSuperview];
                }];
            }];
            [naivController release];
            [controller release];
        }
            break;
        case 4:
        {//汽车商城
            CarShopViewController *controller = [[CarShopViewController alloc] init];
            
            UINavigationController *naivController = [[UINavigationController alloc] initWithRootViewController:controller];

            [self presentViewController:naivController animated:YES completion:^{
                
                [self hideCircleView];
                
                UIView *imgv = [self.view viewWithTag:1016];
                imgv.alpha = 1;
                [UIView animateWithDuration:0.2 animations:^{
                    imgv.alpha = 0;
                } completion:^(BOOL finished) {
                    [imgv removeFromSuperview];
                }];
            }];
            
            [naivController release];
            [controller release];
        }
            break;
        case 5:
        {//设置
            SettingViewController *controller = [[SettingViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navi animated:YES completion:^{
                
                [self hideCircleView];
                
                UIView *imgv = [self.view viewWithTag:1016];
                imgv.alpha = 1;
                [UIView animateWithDuration:0.2 animations:^{
                    imgv.alpha = 0;
                } completion:^(BOOL finished) {
                    [imgv removeFromSuperview];
                }];
            }];
            [navi release];
            [controller release];
        }
            break;
        case 6:
        {//洗车
            WashingCarViewController *controller = [[WashingCarViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navi animated:YES completion:nil];
            [controller release];
            [navi release];
        }
            break;
        case 7:
        {//加油
            AddOilViewController *controller = [[AddOilViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navi animated:YES completion:nil];
            [controller release];
            [navi release];
        }
            break;
        case 8:
        {//停车场
            ParkingViewController *controller = [[ParkingViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navi animated:YES completion:nil];
            [controller release];
            [navi release];
        }
            break;
        case 9:
        {//违章查询
            BreakRulesViewController *controller = [[BreakRulesViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navi animated:YES completion:nil];
            [controller release];
            [navi release];
        }
            break;
        default:
            break;
    }
    
}

- (void)changCircleViewImageForward:(NSTimer *)timer
{
    
    NSString *str = [NSString stringWithFormat:@"tanchu_%05d",++_countForCircleView];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:str ofType:@"png"]];
    [circleView setImage:image];
    
    if (_countForCircleView == 23)
    {
        _isAnimating = NO;
        [timer invalidate];
        
        float offsetY = 0;
        
        if ([MyUtil isIphone5]) {
            offsetY = 40;
        }
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 170 + offsetY, 320, 273+offsetY)];
        imgv.tag = 1016;
        imgv.image = [UIImage imageNamed:@"circle_bg"];
        [self.view insertSubview:imgv belowSubview:circleView];
        
        imgv.alpha = 0;
        
        [UIView animateWithDuration:0.2 animations:^{
            imgv.alpha = 1;
        }];
        
        [self loadButtonsOnCircleView];
    }
}

//弹出视图 回收的
- (void)changCircleViewImageBack:(NSTimer *)timer
{
    
    NSString *str = [NSString stringWithFormat:@"tanchu_%05d",--_countForCircleView];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:str ofType:@"png"]];
    [circleView setImage:image];
    
    if (_countForCircleView == 0)
    {
        [timer invalidate];
        [circleView removeFromSuperview];
        circleView = nil;
        _isAnimating = NO;
        
        UIView *imgv = [self.view viewWithTag:1016];
        imgv.alpha = 1;
        [UIView animateWithDuration:0.2 animations:^{
            imgv.alpha = 0;
        } completion:^(BOOL finished) {
            [imgv removeFromSuperview];
        }];
    }
}


-(void)initViews
{
    UIImageView *navbg=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    navbg.image=[UIImage imageNamed:@"home_nav"];
    [self.view addSubview:navbg];
    [navbg release];
    
//    UIButton *morebtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    morebtn.frame=CGRectMake(320.0-40.0, 4.5, 35.0, 35.0);
//    morebtn.tag=MoreTag;
//    [morebtn setImage:[UIImage imageNamed:@"more_btn"] forState:UIControlStateNormal];
//    [morebtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:morebtn];
    
    UIView *homebg=[[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 365.0+(iPhone5?88:0))];
    homebg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    [self.view addSubview:homebg];
    [homebg release];
    
    UIImageView *timebg=[[UIImageView alloc] initWithFrame:CGRectMake((320-305.5)/2, navbg.frame.origin.y+navbg.frame.size.height, 305.5, 43.0)];
    timebg.image=[UIImage imageNamed:@"time_bar"];
    timebg.userInteractionEnabled=YES;
    [self.view addSubview:timebg];
    [timebg release];
    
    UIButton *refreshbtn=[[UIButton alloc] initWithFrame:CGRectMake(15.0,0.0, 60.0, 35.0)];
    [refreshbtn setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshbtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    refreshbtn.tag=RefreshTag;
    [timebg addSubview:refreshbtn];
    [refreshbtn release];
    
    timetxt=[[UILabel alloc] initWithFrame:CGRectMake(90.0, 4.0, 200.0, 25.0)];
    timetxt.textColor=[UIColor whiteColor];
    timetxt.backgroundColor=[UIColor clearColor];
    [timebg addSubview:timetxt];
    [timetxt release];
    
    left_up_tireImg=[[UIImageView alloc] initWithFrame:CGRectMake(115.0, 123.0, 18.0, 50.0)];
    [self.view addSubview:left_up_tireImg];
    [left_up_tireImg release];
    
    left_down_tireImg=[[UIImageView alloc] initWithFrame:CGRectMake(115.0, 216.0, 18.0, 50.0)];
    [self.view addSubview:left_down_tireImg];
    [left_down_tireImg release];
    
    right_up_tireImg=[[UIImageView alloc] initWithFrame:CGRectMake(180.0, 123.0, 18.0, 50.0)];
    [self.view addSubview:right_up_tireImg];
    [right_up_tireImg release];
    
    right_down_tireImg=[[UIImageView alloc] initWithFrame:CGRectMake(180.0, 216.0, 18.0, 50.0)];
    [self.view addSubview:right_down_tireImg];
    [right_down_tireImg release];
    
    carImg=[[UIImageView alloc] initWithFrame:CGRectMake((320-164.0)/2,timebg.frame.size.height+timebg.frame.origin.y+10.0, 164.0, 197.0)];
    carImg.image=[UIImage imageNamed:@"car_normal"];
    [self.view addSubview:carImg];
    [carImg release];
    
    left_up_doorImg=[[UIImageView alloc] initWithFrame:CGRectMake(80.0, 153.0, 54.0, 46.5)];
    [self.view addSubview:left_up_doorImg];
    [left_up_doorImg release];
    
    left_down_doorImg=[[UIImageView alloc] initWithFrame:CGRectMake(80.0, 196.5, 54.0, 46.5)];
    [self.view addSubview:left_down_doorImg];
    [left_down_doorImg release];
    
    right_up_doorImg=[[UIImageView alloc] initWithFrame:CGRectMake(185.0, 153.0, 54.0, 46.5)];
    [self.view addSubview:right_up_doorImg];
    [right_up_doorImg release];
    
    right_down_doorImg=[[UIImageView alloc] initWithFrame:CGRectMake(185.0, 196.5, 54.0, 46.5)];
    [self.view addSubview:right_down_doorImg];
    [right_down_doorImg release];
    
    carTireImg=[[UIImageView alloc] initWithFrame:CGRectMake(25.0,timebg.frame.size.height+timebg.frame.origin.y+30.0,52.0 ,57.0)];
    carTireImg.image=[UIImage imageNamed:@"tire_normal"];
    [self.view addSubview:carTireImg];
    [carTireImg release];
    
    doorImg=[[UIImageView alloc] initWithFrame:CGRectMake(25.0,carTireImg.frame.size.height+carTireImg.frame.origin.y+49.0,52.0 ,57.0)];
    doorImg.image=[UIImage imageNamed:@"door_close"];
    [self.view addSubview:doorImg];
    [doorImg release];
    
    lightImg=[[UIImageView alloc] initWithFrame:CGRectMake(240.0,timebg.frame.size.height+timebg.frame.origin.y+30.0,52.0 ,57.0)];
    lightImg.image=[UIImage imageNamed:@"light_normal"];
    [self.view addSubview:lightImg];
    [lightImg release];
    
    maintainImg=[[UIImageView alloc] initWithFrame:CGRectMake(240.0,lightImg.frame.size.height+lightImg.frame.origin.y+49.0,52.0 ,57.0)];
    maintainImg.image=[UIImage imageNamed:@"maintain"];
    [self.view addSubview:maintainImg];
    [maintainImg release];
    
    soiltxt=[[UILabel alloc] initWithFrame:CGRectMake(280.0, carImg.frame.size.height+carImg.frame.origin.y, 100.0, 22.0)];
    soiltxt.backgroundColor=[UIColor clearColor];
    soiltxt.textColor=[UIColor whiteColor];
    [self.view addSubview:soiltxt];
    [soiltxt release];
    [soiltxt setHidden:YES];
    
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(20.0, soiltxt.frame.size.height+soiltxt.frame.origin.y, 80.0, 25.0)];
    label1.backgroundColor=[UIColor clearColor];
    label1.text=@"燃油余量";
    label1.textColor=[UIColor whiteColor];
    [self.view addSubview:label1];
    [label1 release];
    
    leftSoil=[[DDProgressView alloc] initWithFrame:CGRectMake(label1.frame.size.width+label1.frame.origin.x+5, soiltxt.frame.size.height+soiltxt.frame.origin.y, 200.0, 0.0)];
    [leftSoil setOuterColor: [UIColor clearColor]] ;
    [leftSoil setInnerColor: [UIColor lightGrayColor]] ;
    [leftSoil setEmptyColor: [UIColor darkGrayColor]] ;
    [self.view addSubview: leftSoil];
    [leftSoil release];
    
    lifetxt=[[UILabel alloc] initWithFrame:CGRectMake(20.0, leftSoil.frame.size.height+leftSoil.frame.origin.y, 100.0, 22.0)];
    lifetxt.backgroundColor=[UIColor clearColor];
    lifetxt.text=@"暂时不支持";
    lifetxt.textColor=[UIColor whiteColor];
    [self.view addSubview:lifetxt];
    [lifetxt release];
    
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(20.0, lifetxt.frame.size.height+lifetxt.frame.origin.y, 80.0, 25.0)];
    label2.backgroundColor=[UIColor clearColor];
    label2.text=@"机油寿命";
    label2.textColor=[UIColor whiteColor];
    [self.view addSubview:label2];
    [label2 release];
    
    soillife=[[DDProgressView alloc] initWithFrame:CGRectMake(label2.frame.size.width+label2.frame.origin.x+5, lifetxt.frame.size.height+lifetxt.frame.origin.y, 200.0, 0.0)];
    [soillife setOuterColor: [UIColor clearColor]] ;
    [soillife setInnerColor: [UIColor lightGrayColor]] ;
    [soillife setEmptyColor: [UIColor darkGrayColor]] ;
    [self.view addSubview: soillife];
    [soillife release];
    
    for(int i=0;i<5;i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=110+i;
        [button setExclusiveTouch:YES];
        button.frame=CGRectMake(64*i,460.0-70.5+(iPhone5?88:0), 64.0, 70.5);
        NSString *imagename=[NSString stringWithFormat:@"home_btn%d",i];
        button.backgroundColor=[UIColor clearColor];
        [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)initCarStatus:(CarStatus *)carstatus
{
    timetxt.text=[UIHelper TimeFormat:carstatus.data];
    if(carstatus.fuel==-1)
    {
        soiltxt.text=[NSString stringWithFormat:@"%@",@"未获取到数据"];
        [leftSoil setProgress:0.0];
    }
    else
    {
        soiltxt.text=[NSString stringWithFormat:@"%d %@",carstatus.fuel,@"%"];
        [leftSoil setProgress:[[NSString stringWithFormat:@"%d",carstatus.fuel] doubleValue]/100];
    }
    if(carstatus.left_up_door==0&&carstatus.left_down_door==0&&carstatus.right_up_door==0&&carstatus.right_down_door==0)
    {
        [doorImg setImage:[UIImage imageNamed:@"door_close"]];
    }
    else
    {
        [doorImg setImage:[UIImage imageNamed:@"door_open"]];
    }
    if(carstatus.left_up_door==0)
    {
        left_up_doorImg.image=[UIImage imageNamed:@"left_up_door_close"];
    }
    else
    {
        left_up_doorImg.image=[UIImage imageNamed:@"left_up_door_open"];
    }
    if(carstatus.left_down_door==0)
    {
        left_down_doorImg.image=[UIImage imageNamed:@"left_down_door_close"];
    }
    else
    {
        left_down_doorImg.image=[UIImage imageNamed:@"left_down_door_open"];
    }
    if(carstatus.right_up_door==0)
    {
        right_up_doorImg.image=[UIImage imageNamed:@"right_up_door_close"];
    }
    else
    {
        right_up_doorImg.image=[UIImage imageNamed:@"right_up_door_open"];
    }
    if(carstatus.right_down_door==0)
    {
        right_down_doorImg.image=[UIImage imageNamed:@"right_down_door_close"];
    }
    else
    {
        right_down_doorImg.image=[UIImage imageNamed:@"right_down_door_open"];
    }
    if(carstatus.isHaveTire==0)
    {
        if(carstatus.left_up_tire_press==0)
        {
            left_up_tireImg.image=[UIImage imageNamed:@"car_tire_normal"];
        }
        else
        {
            left_up_tireImg.image=[UIImage imageNamed:@"car_tire_high"];
        }
        if(carstatus.left_down_tire_press==0)
        {
            left_down_tireImg.image=[UIImage imageNamed:@"car_tire_normal"];
        }
        else
        {
            left_down_tireImg.image=[UIImage imageNamed:@"car_tire_high"];
        }
        if(carstatus.right_up_tire_press==0)
        {
            right_up_tireImg.image=[UIImage imageNamed:@"car_tire_normal"];
        }
        else
        {
            right_up_tireImg.image=[UIImage imageNamed:@"car_tire_high"];
        }
        if(carstatus.right_down_tire_press==0)
        {
            right_down_tireImg.image=[UIImage imageNamed:@"car_tire_normal"];
        }
        else
        {
            right_down_tireImg.image=[UIImage imageNamed:@"car_tire_high"];
        }
        if(carstatus.left_up_tire_press==0&&carstatus.left_down_tire_press==0&&carstatus.right_up_tire_press==0&&carstatus.right_down_tire_press==0)
        {
            [carTireImg setImage:[UIImage imageNamed:@"tire_normal"]];
        }else
        {
            [carTireImg setImage:[UIImage imageNamed:@"tire_high"]];
        }
    }
    if(carstatus.dipped_beam_status==0&&carstatus.high_beam_status==0)
    {
        [lightImg setImage:[UIImage imageNamed:@"light_close"]];
    }
    if(carstatus.dipped_beam_status==1||carstatus.high_beam_status==1)
    {
        [lightImg setImage:[UIImage imageNamed:@"light_open"]];
    }
    if(carstatus.dipped_beam_status==3||carstatus.high_beam_status==3)
    {
        [lightImg setImage:[UIImage imageNamed:@"light_error"]];
    }
}


-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0+(iPhone5?88:0))];
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
    progressdialog.center = self.view.center;
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

-(void)clickBtn:(id)sender
{
    if(![MyDefaults getUserName])
    {
        LoginViewController *login=[[LoginViewController alloc] init];
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:login];
        if([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
        }
        [self presentModalViewController:nav animated:YES];
        [login release];
        [nav release];
        return;
    }
    UIButton *button=(UIButton *)sender;
    switch (button.tag) {
        case 110:
        {
            SaferTabViewController *safer=[[SaferTabViewController alloc] init];
            [self presentModalViewController:safer animated:YES];
            [safer release];
        }
            break;
        case 111:
        {
            SecTabViewControll *sec=[[SecTabViewControll alloc] init];
            [self presentModalViewController:sec animated:YES];
            [sec release];
        }
            break;
        case 112:
        {
            UnionTabViewController *uniontab=[[UnionTabViewController alloc] init];
            [self presentModalViewController:uniontab animated:YES];
            [uniontab release];
            
        }
            break;
        case 113:
        {
            GuideTabViewController *guide=[[GuideTabViewController alloc] init];
            [self presentModalViewController:guide animated:YES];
            [guide release];
        }
            break;
        case 114:
        {
//            MallViewController *mall=[[MallViewController alloc] init];
//            [self.navigationController pushViewController:mall animated:YES];
//            [mall release];
            SettingViewController *setting=[[SettingViewController alloc] init];
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:setting];
            if([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
            }
            [self presentModalViewController:nav animated:YES];
            [setting release];
            [nav release];

        }
            break;
        case MoreTag:
        {
//            SettingViewController *setting=[[SettingViewController alloc] init];
//            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:setting];
//            if([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//            {
//                [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
//            }
//            [self presentModalViewController:nav animated:YES];
//            [setting release];
//            [nav release];
        }
            break;
        case RefreshTag:
        {
            [self createProgressDialog];
            [NSThread detachNewThreadSelector:@selector(getDataInThread) toTarget:self withObject:nil];
        }
            break;
        default:
            break;
    }
}

-(void)getDataInThread
{
    NSData *data=[[NetService singleHttpService] sendCommantBywake:WAKE];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            data=[[NetService singleHttpService] sendCommantBystatus:@"RP-VEH-CON"];
            if(data)
            {
                NSDictionary *nd1=[data objectFromJSONData];
                if([[nd1 objectForKey:@"resp_status"] isEqualToString:@"OK"])
                {
                    [NSThread sleepForTimeInterval:5.0];
                    data=[[NetService singleHttpService] getCarCondition];
                    if(data)
                    {
                        [self performSelectorOnMainThread:@selector(getResult:) withObject:data waitUntilDone:NO];
                    }else
                    {
                        [self performSelectorOnMainThread:@selector(getFail:) withObject:@"网络异常!" waitUntilDone:NO];
                    }
                }else
                {
                    [self performSelectorOnMainThread:@selector(getFail:) withObject:@"指令下发失败" waitUntilDone:NO];
                }
            }
            else
            {
                [self performSelectorOnMainThread:@selector(getFail:) withObject:@"网络异常!" waitUntilDone:NO];
            }
        }else
        {
            [self performSelectorOnMainThread:@selector(getFail:) withObject:@"唤醒失败" waitUntilDone:NO];
        }
    }
    else
    {
        [self performSelectorOnMainThread:@selector(getFail:) withObject:@"网络异常!" waitUntilDone:NO];
    }
}

-(void)getResult:(NSData *)data
{
    [self closeProgressDialog];
    NSDictionary *nd=[data objectFromJSONData];
   // NSLog(@"=====%@",nd);
    if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
    {
        BOOL iscuess=[[ChinaTspDao singleDao] deleteCarInfo];
        if(iscuess)
        {
            NSLog(@"---删除成功");
        }
        NSDictionary *respNd=[nd objectForKey:@"resp_data"];
        int time=[[respNd objectForKey:@"record_timestamp"] longLongValue];
        timetxt.text=[UIHelper TimeFormat:[[respNd objectForKey:@"record_timestamp"] longLongValue]];
        int fuel=[[respNd objectForKey:@"remaining_fuel"] intValue];
        int left_up_door=[[respNd objectForKey:@"driver_door_status"] intValue];
        int left_down_door=[[respNd objectForKey:@"rear_left_door_status"] intValue];
        int right_up_door=[[respNd objectForKey:@"copilot_door_status"] intValue];
        int right_down_door=[[respNd objectForKey:@"rear_right_door_status"] intValue];
        int ishavetire=0;
        int left_up_tire=0;
        int left_down_tire=0;
        int right_up_tire=0;
        int right_down_tire=0;
        if([respNd objectForKey:@"tyre_pressure_warning"])
        {
            ishavetire=0;
            NSString *tireStr=[respNd objectForKey:@"tyre_pressure_warning"];
            NSArray *array=[tireStr componentsSeparatedByString:@","];
            left_up_tire=[[array objectAtIndex:0] intValue];
            left_down_tire=[[array objectAtIndex:3] intValue];
            right_up_tire=[[array objectAtIndex:1] intValue];
            right_down_tire=[[array objectAtIndex:2] intValue];
        }
        else
        {
            ishavetire=1;
        }
        int dipped_beam_status=[[respNd objectForKey:@"dipped_beam_status"] intValue];
        int high_beam_status=[[respNd objectForKey:@"high_beam_status"] intValue];
        CarStatus *carstatus=[[CarStatus alloc] init];
        carstatus.data=time;
        carstatus.isHaveTire=ishavetire;
        carstatus.fuel=fuel;
        carstatus.left_up_door=left_up_door;
        carstatus.left_down_door=left_down_door;
        carstatus.right_up_door=right_up_door;
        carstatus.right_down_door=right_down_door;
        carstatus.left_up_tire_press=left_up_tire;
        carstatus.left_down_tire_press=left_down_tire;
        carstatus.right_up_tire_press=right_up_tire;
        carstatus.right_down_tire_press=right_down_tire;
        carstatus.dipped_beam_status=dipped_beam_status;
        carstatus.high_beam_status=high_beam_status;
        [self initCarStatus:carstatus];
        BOOL isinsert=[[ChinaTspDao singleDao] insertCarInfo:carstatus];
        [carstatus release];
        if(isinsert)
        {
            NSLog(@"插入成功");
        }
    }
    else
    {
        [UIHelper showAlertview:@"获取数据失败"];
    }
}

-(void)getFail:(NSString *)str
{
    [self closeProgressDialog];
    [UIHelper showAlertview:str];
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
