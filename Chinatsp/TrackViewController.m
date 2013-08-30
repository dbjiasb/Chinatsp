//
//  TrackViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#define UserLocTag 102
#define CarLocTag 103
#define SendTrackTag 104
#define SendStartTag 105

#import "TrackViewController.h"
#import "NetService.h"
#import "UIHelper.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "config.h"

@interface TrackViewController ()
{
    AppDelegate *appdelegate;
}
@end

@implementation TrackViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"定位追踪";
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    [self initViews];
    appdelegate=[[UIApplication sharedApplication] delegate];
    //mapview.delegate=self;
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    mapview=[[BMKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0-44.0-70.5+(iPhone5?88:0))];
    [mapview setZoomLevel:14];
    [self.view addSubview:mapview];
    [mapview release];
    
    user_loc=[[UIButton alloc] init];
    user_loc.frame=CGRectMake(160.0-57.0-5.0,460.0-160.0+(iPhone5?88:0), 57.0, 42.0);
    user_loc.tag=UserLocTag;
    [user_loc addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [user_loc setImage:[UIImage imageNamed:@"user_location"] forState:UIControlStateNormal];
    [self.view addSubview:user_loc];
    [user_loc release];
    
    car_loc=[[UIButton alloc] init];
    car_loc.frame=CGRectMake(165.0, 460.0-160.0+(iPhone5?88:0), 57.0, 42.0);
    car_loc.tag=CarLocTag;
    [car_loc addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [car_loc setImage:[UIImage imageNamed:@"car_maplocation"] forState:UIControlStateNormal];
    [self.view addSubview:car_loc];
    [car_loc release];
    
    send_track=[[UIButton alloc] init];
    send_track.frame=CGRectMake(0.0, 0.0, 160, 43.0);
    send_track.tag=SendTrackTag;
    [send_track addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [send_track setImage:[UIImage imageNamed:@"send_track"] forState:UIControlStateNormal];
    [self.view addSubview:send_track];
    [send_track release];
    
    send_start=[[UIButton alloc] init];
    send_start.frame=CGRectMake(160.0, 0.0, 160.0, 43.0);
    send_start.tag=SendStartTag;
    [send_start addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [send_start setImage:[UIImage imageNamed:@"send_start"] forState:UIControlStateNormal];
    [self.view addSubview:send_start];
    [send_start release];
   
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
        case UserLocTag:
            if(appdelegate.usercoordinate.latitude!=0.000000)
            {
                [mapview setCenterCoordinate:appdelegate.usercoordinate animated:YES];
            }
            break;
        case CarLocTag:
            [self createProgressDialog];
            [NSThread detachNewThreadSelector:@selector(getCarLoactionInThread) toTarget:self withObject:nil];
            break;
        case SendTrackTag:
            [self createProgressDialog];
            [NSThread detachNewThreadSelector:@selector(sendCommandInThread) toTarget:self withObject:nil];
            break;
        case SendStartTag:
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
        NSLog(@"1---");
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
