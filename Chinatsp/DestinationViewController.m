//
//  DestinationViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-16.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#define UserLocationTag 102
#define CarLocationTag 103
#define SearchTag 104
#define RealRoadTag 105
#define NearTag 106

#import "DestinationViewController.h"
#import "BMapKit.h"
#import "JSONKit.h"
#import "NetService.h"
#import "UIHelper.h"
#import "PlaceMark.h"
#import "CallOutAnnotationView.h"
#import "CalloutMapAnnotation.h"
#import "MapCell.h"
#import "CategoryViewController.h"
#import "AppDelegate.h"
#import "config.h"
#import <QuartzCore/QuartzCore.h>

@interface DestinationViewController ()
{
    CalloutMapAnnotation *_calloutAnnotation;
    AppDelegate *appDelegate;
}
@end

@implementation DestinationViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
        isFlag=NO;
        self.title=@"目的地查询";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    [self initViews];
//    self.mMapview.delegate=self;
    appDelegate=[[UIApplication sharedApplication] delegate];
 //   self.mKSearch=[[[BMKSearch alloc] init] autorelease];
//    self.mKSearch.delegate=self;
//    [BMKSearch setPageCapacity:30];
    UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.mMapview addGestureRecognizer:longpress];
    [longpress release];
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    self.mMapview=[[[BMKMapView alloc] initWithFrame:CGRectMake(0.0,0.0, 320.0, 460.0-44.0-70.5+(iPhone5?88:0))] autorelease];
    [self.mMapview setZoomLevel:14];
    [self.view addSubview:self.mMapview];
    
    UIImageView *searchbg=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40)];
    searchbg.image=[UIImage imageNamed:@"search_bg"];
    searchbg.userInteractionEnabled=YES;
    [self.view addSubview:searchbg];
    [searchbg release];
    
    input=[[UITextField alloc] initWithFrame:CGRectMake(5.0, (40.0-32.0)/2, 188.0, 32.0)];
    input.background=[UIImage imageNamed:@"destination_input_bg"];
    input.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    input.borderStyle=UITextBorderStyleNone;
    input.delegate=self;
    [searchbg addSubview:input];
    [input release];
    
    UIButton *searchbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchbtn.frame=CGRectMake(input.frame.size.width+input.frame.origin.x+5.0, (40.0-28.5)/2, 56.5, 28.5);
    searchbtn.tag=SearchTag;
    [searchbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchbtn setImage:[UIImage imageNamed:@"search_btn"] forState:UIControlStateNormal];
    [searchbg addSubview:searchbtn];
    
    UIButton *nearbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    nearbtn.frame=CGRectMake(searchbtn.frame.size.width+searchbtn.frame.origin.x+5, (40.0-28.5)/2, 56.5, 28.5);
    nearbtn.tag=NearTag;
    [nearbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nearbtn setImage:[UIImage imageNamed:@"near_btn"] forState:UIControlStateNormal];
    [searchbg addSubview:nearbtn];
    
    UIButton *realroad=[UIButton buttonWithType:UIButtonTypeCustom];
    realroad.frame=CGRectMake(40.0, 460.0-160.0+(iPhone5?88:0), 92.0, 41.0);
    realroad.tag=RealRoadTag;
    [realroad addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [realroad setImage:[UIImage imageNamed:@"real_roadcond"] forState:UIControlStateNormal];
    [self.view addSubview:realroad];
    
    UIButton *userlocation=[UIButton buttonWithType:UIButtonTypeCustom];
    userlocation.tag=UserLocationTag;
    userlocation.frame=CGRectMake(realroad.frame.origin.x+realroad.frame.size.width+15.0, 460.0-160.0+(iPhone5?88:0), 57.0, 42.0);
    [userlocation addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [userlocation setImage:[UIImage imageNamed:@"user_location"] forState:UIControlStateNormal];
    [self.view addSubview:userlocation];
    
    UIButton *carloaction=[UIButton buttonWithType:UIButtonTypeCustom];
    carloaction.tag=CarLocationTag;
    [carloaction addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    carloaction.frame=CGRectMake(userlocation.frame.size.width+userlocation.frame.origin.x+15.0, 460.0-160.0+(iPhone5?88:0), 57.0, 42.0);
    [carloaction setImage:[UIImage imageNamed:@"car_maplocation"] forState:UIControlStateNormal];
    [self.view addSubview:carloaction];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mMapview viewWillAppear];
    self.mMapview.delegate=self;
    appDelegate.mKSearch.delegate=self;
    [self.mMapview setShowsUserLocation:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mMapview viewWillDisappear];
    self.mMapview.delegate=nil;
    appDelegate.mKSearch.delegate=nil;
    [self.mMapview setShowsUserLocation:NO];
}

-(void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state==UIGestureRecognizerStateBegan)
    {
        NSArray* array = [NSArray arrayWithArray:self.mMapview.annotations];
        [self.mMapview removeAnnotations:array];
//        array = [NSArray arrayWithArray:self.mMapview.overlays];
//        [self.mMapview removeOverlays:array];
        CGPoint point=[longPress locationInView:self.mMapview];
        CLLocationCoordinate2D coordinate=[self.mMapview convertPoint:point toCoordinateFromView:self.mMapview];
        BOOL flag=[appDelegate.mKSearch reverseGeocode:coordinate];
        if(!flag)
        {
            NSLog(@"failed");
        }
    }
}

-(void)btnClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case UserLocationTag:
            if(appDelegate.usercoordinate.latitude!=0.000000)
            {
                [self.mMapview setCenterCoordinate:appDelegate.usercoordinate animated:YES];
            }
            break;
        case CarLocationTag:
            [self createProgressDialog];
            [NSThread detachNewThreadSelector:@selector(getCarLoactionInThread) toTarget:self withObject:nil];
            break;
        case RealRoadTag:
        {
            if(isFlag)
            {
                isFlag=NO;
                [self.mMapview setMapType:BMKMapTypeStandard];
            }
            else
            {
                [self.mMapview setMapType:BMKMapTypeTrafficOn];
                isFlag=YES;
            }
            
        }
            break;
        case SearchTag:
        {
            [input resignFirstResponder];
            BOOL flag = [appDelegate.mKSearch poiSearchNearBy:input.text center:appDelegate.usercoordinate radius:5000 pageIndex:0];
            if (!flag) {
                
                [UIHelper showAlertview:@"搜索失败"];
            }else
            {
                NSArray* array = [NSArray arrayWithArray:self.mMapview.annotations];
                [self.mMapview removeAnnotations:array];
//                array = [NSArray arrayWithArray:self.mMapview.overlays];
//                [self.mMapview removeOverlays:array];
            }
        }
            break;
        case NearTag:
            [input resignFirstResponder];
            if(appDelegate.usercoordinate.latitude==0.000000)
            {
                [UIHelper showAlertview:@"正在定位中"];
                return;
            }
            NSArray* array = [NSArray arrayWithArray:self.mMapview.annotations];
            [self.mMapview removeAnnotations:array];
            
            [self pushCategoryView:appDelegate.usercoordinate.latitude longitude:appDelegate.usercoordinate.longitude];
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

        NSArray* array = [NSArray arrayWithArray:self.mMapview.annotations];
        [self.mMapview removeAnnotations:array];
//        array = [NSArray arrayWithArray:self.mMapview.overlays];
//        [self.mMapview removeOverlays:array];
        
        NSDictionary *nd=[data objectFromJSONData];
        NSDictionary *currentNd=[[nd objectForKey:@"resp_data"] objectForKey:@"current"];
        newannotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude =[[currentNd objectForKey:@"lat"] floatValue];
        coor.longitude = [[currentNd objectForKey:@"lng"] floatValue];
        newannotation.coordinate = coor;
        newannotation.title = @"当前汽车的位置";
        [self.mMapview addAnnotation:newannotation];
        [newannotation release];
        [self.mMapview setCenterCoordinate:CLLocationCoordinate2DMake([[currentNd objectForKey:@"lat"] floatValue], [[currentNd objectForKey:@"lng"] floatValue]) animated:YES];
    }
    else
    {
        [UIHelper showAlertview:@"获取不到车辆的位置"];
    }
}

-(void)pushCategoryView:(double)latitude longitude:(double)longitude
{
    NSArray* array = [NSArray arrayWithArray:self.mMapview.annotations];
    [self.mMapview removeAnnotations:array];
    
    CategoryViewController *category=[[CategoryViewController alloc] init];
    NSNumber *lat=[NSNumber numberWithDouble:latitude];
    NSNumber *lon=[NSNumber numberWithDouble:longitude];
    [category setValue:lat forKey:@"latitude"];
    [category setValue:lon forKey:@"longitude"];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:category];
    if([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    [self presentModalViewController:nav animated:YES];
    [category release];
    [nav release];
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

-(void)iCloudyDataInsert:(Collect *)collect
{
    NSData *data=[[NetService singleHttpService] insertClouy:collect];
    [self performSelectorOnMainThread:@selector(getInsertCloudyResult:) withObject:data waitUntilDone:NO];
}

-(void)getInsertCloudyResult:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([@"OK" isEqualToString:[nd objectForKey:@"resp_status"]])
        {
            [UIHelper showAlertview:@"收藏成功"];
        }else
        {
            [UIHelper showAlertview:@"收藏失败,请稍后在试"];
        }
    }else
    {
        [UIHelper showAlertview:@"网络异常"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--委托
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [input resignFirstResponder];
    return YES;
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        appDelegate.usercoordinate=CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
//        [self.mMapview setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) animated:YES];
	}
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"] autorelease];
        }
        annotationView.mapCell.maptitle.text=((CalloutMapAnnotation *)annotation).addr;
        annotationView.mapCell.latitude=((CalloutMapAnnotation *)annotation).latitude;
        annotationView.mapCell.longitude=((CalloutMapAnnotation *)annotation).longitude;
        annotationView.delgete=self;
        CAKeyframeAnimation *cfa = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        cfa.duration = 0.3;
        cfa.fillMode = kCAFillModeForwards;
        
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:0];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        
        cfa.values = values;
        [annotationView.layer addAnimation:cfa forKey:nil];
        return annotationView;
	}
    else if ([annotation isKindOfClass:[PlaceMark class]])
    {
        BMKAnnotationView *annotationView =[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"] autorelease];
            annotationView.canShowCallout = NO;
            ((BMKPinAnnotationView *)annotationView).animatesDrop=YES;
        }
		annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
		return annotationView;
    }
    else if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *AnnotationViewID=@"annotationViewID";
        BMKAnnotationView *newAnnotation = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if(newAnnotation==nil)
        {
            BMKPinAnnotationView *newAnnotation = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"] autorelease];
            newAnnotation.pinColor = BMKPinAnnotationColorPurple;
            newAnnotation.animatesDrop = YES;
            newAnnotation.draggable = NO;
            return newAnnotation;
        }
    }
	return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[PlaceMark class]])
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[[CalloutMapAnnotation alloc]
                              initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude addr:((PlaceMark *)view.annotation).addr] autorelease];
        [mapView addAnnotation:_calloutAnnotation];
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
    else if ([view isKindOfClass:[CallOutAnnotationView class]])
    {
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationView class]])
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude)
        {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

-(void) onGetPoiResult:(NSArray *)poiResultList searchType:(int)type errorCode:(int)error
{
    NSLog(@"1-----%d",error);
    if(error==BMKErrorOk)
    {
        BMKPoiResult* result = [poiResultList objectAtIndex:0];
        NSMutableArray *annotations=[[[NSMutableArray alloc] init] autorelease];
		for (int i = 0; i < result.poiInfoList.count; i++) {
			BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            PlaceMark *placeMark =[[PlaceMark alloc] initWithCoord:poi.address Coord:poi.pt];
            [annotations addObject:placeMark];
            [placeMark release];
		}
        if([annotations count]!=0)
        {
            PlaceMark *placemark=[annotations objectAtIndex:0];
            [self.mMapview setCenterCoordinate:placemark.coordinate animated:YES];
        }
        [self.mMapview addAnnotations:annotations];
//        [self.mMapview addAnnotation:newannotation];
    }
    
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error;
{
    if(error==BMKErrorOk)
    {
        PlaceMark *placeMark =[[PlaceMark alloc] initWithCoord:result.strAddr Coord:result.geoPt];
        [self.mMapview addAnnotation:placeMark];
        [placeMark release];
    }
    NSLog(@"2-----%d",error);
}

-(void)iCloudyData:(Collect *)collect
{
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(iCloudyDataInsert:) toTarget:self withObject:collect];
}

-(void)iSearchData:(double)latitude longitude:(double)longitude
{
    [self pushCategoryView:latitude longitude:longitude];
}

-(void)dealloc
{
    self.mMapview=nil;
//    self.mKSearch=nil;
    [super dealloc];
}


@end
