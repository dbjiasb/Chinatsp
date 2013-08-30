//
//  RoadRescueViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//
#define HelpTag 102
#define UserLocationTag 103
#define CarLocationTag 104
#define HospitalTag 105

#import "RoadRescueViewController.h"
#import "NetService.h"
#import "JSONKit.h"
#import "UIHelper.h"
#import "AppDelegate.h"
#import "config.h"

@interface RoadRescueViewController ()
{
    AppDelegate *appdelegate;
}
@end

@implementation RoadRescueViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"道路救援";
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    appdelegate=[[UIApplication sharedApplication] delegate];
    [self initViews];
    //mapview.delegate=self;
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    mapview=[[BMKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0-44.0-70.5+(iPhone5?88:0))];
    [mapview setZoomLevel:14];
    [self.view addSubview:mapview];
    [mapview release];
    
    UIButton *help=[UIButton buttonWithType:UIButtonTypeCustom];
    help.tag=HelpTag;
    help.frame=CGRectMake(10.0, 460.0-160.0+(iPhone5?88:0), 93.0, 42.0);
    [help setImage:[UIImage imageNamed:@"posthelp"] forState:UIControlStateNormal];
    [help addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:help];
    
    UIButton *userlocation=[UIButton buttonWithType:UIButtonTypeCustom];
    userlocation.tag=UserLocationTag;
    userlocation.frame=CGRectMake(help.frame.size.width+help.frame.origin.x+10.0, 460.0-160.0+(iPhone5?88:0), 57.0, 42.0);
    [userlocation addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [userlocation setImage:[UIImage imageNamed:@"user_location"] forState:UIControlStateNormal];
    [self.view addSubview:userlocation];
    
    UIButton *carloaction=[UIButton buttonWithType:UIButtonTypeCustom];
    carloaction.tag=CarLocationTag;
    [carloaction addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    carloaction.frame=CGRectMake(userlocation.frame.size.width+userlocation.frame.origin.x+10, 460.0-160.0+(iPhone5?88:0), 57.0, 42.0);
    [carloaction setImage:[UIImage imageNamed:@"car_maplocation"] forState:UIControlStateNormal];
    [self.view addSubview:carloaction];
    
//    UIButton *hospital=[UIButton buttonWithType:UIButtonTypeCustom];
//    hospital.tag=HospitalTag;
//    [hospital addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    hospital.frame=CGRectMake(carloaction.frame.size.width+carloaction.frame.origin.x+10, 460.0-160.0+(iPhone5?88:0), 57.0, 42.0);
//    [hospital setImage:[UIImage imageNamed:@"hospital"] forState:UIControlStateNormal];
//    [self.view addSubview:hospital];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mapview viewWillAppear];
    mapview.delegate=self;
    [mapview setShowsUserLocation:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [mapview viewWillDisappear];
    mapview.delegate=nil;
    [mapview setShowsUserLocation:NO];
}

-(void)btnClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case UserLocationTag:
            if(appdelegate.usercoordinate.latitude!=0.000000)
            {
                [mapview setCenterCoordinate:appdelegate.usercoordinate animated:YES];
            }
            break;
        case CarLocationTag:
            [self createProgressDialog];
            [NSThread detachNewThreadSelector:@selector(getCarLoactionInThread) toTarget:self withObject:nil];
            break;
        case HelpTag:
            [self createProgressDialog];
            [NSThread detachNewThreadSelector:@selector(sendCommandInThread) toTarget:self withObject:nil];
            break;
        default:
            break;
    }
}

-(void)btnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)getCarLoactionInThread
{
    NSData *data=[[NetService singleHttpService] getLocation];
    [self performSelectorOnMainThread:@selector(getResultByCarLocation:) withObject:data waitUntilDone:NO];
}

-(void)getResultByCarLocation:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        if(carAnnotation)
        {
            [mapview removeAnnotation:carAnnotation];
        }
        NSDictionary *nd=[data objectFromJSONData];
        NSDictionary *currentNd=[[nd objectForKey:@"resp_data"] objectForKey:@"current"];
        carAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude =[[currentNd objectForKey:@"lat"] floatValue];
        coor.longitude = [[currentNd objectForKey:@"lng"] floatValue];
        carAnnotation.coordinate = coor;
        carAnnotation.title = @"当前汽车的位置";
        [mapview addAnnotation:carAnnotation];
        [mapview setCenterCoordinate:CLLocationCoordinate2DMake([[currentNd objectForKey:@"lat"] floatValue], [[currentNd objectForKey:@"lng"] floatValue]) animated:YES];
        [carAnnotation release];
    }
    else
    {
        [UIHelper showAlertview:@"获取不到车辆的位置"];
    }
}

-(void)sendCommandInThread
{
    NSData *data=[[NetService singleHttpService] sendCommantBywake:WAKE];
    data=[[NetService singleHttpService] sendCommantBystatus:@"RP-LOCAL"];
    [self performSelectorOnMainThread:@selector(getResult) withObject:nil waitUntilDone:NO];
}

-(void)getResult
{
    [self closeProgressDialog];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"将转接客服,并追踪车辆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"转接客服", nil];
    [alert show];
    [alert release];
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0-44.0-70.5+(iPhone5?88:0))];
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

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
        appdelegate.usercoordinate=CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	}
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"] autorelease];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
		newAnnotation.animatesDrop = YES;
		newAnnotation.draggable = NO;
		return newAnnotation;
	}
	return nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSString *deviceType=[UIDevice currentDevice].model;
        if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"])
        {
            [UIHelper showAlertview:@"设备没有打电话功能"];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006761146"]];
        }
    }
}

-(void)dealloc
{
    [super dealloc];
}

@end
