//
//  ShowMapViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-23.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "ShowMapViewController.h"
#import "config.h"

@interface ShowMapViewController ()

@end

@implementation ShowMapViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"地图位置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mMapView=[[[BMKMapView alloc] initWithFrame:CGRectMake(0.0,0.0, 320.0, 460.0-44.0+(iPhone5?88:0))] autorelease];
    [self.mMapView setZoomLevel:14];
    [self.view addSubview:self.mMapView];
    //self.mMapView.delegate=self;
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mMapView viewWillAppear];
    self.mMapView.delegate=self;
    [self.mMapView addAnnotations:self.pointArray];
    CLLocationCoordinate2D coor;
    BMKPointAnnotation *poi=[self.pointArray objectAtIndex:0];
    coor=poi.coordinate;
    [self.mMapView setCenterCoordinate:coor];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mMapView viewWillDisappear];
    self.mMapView.delegate=nil;
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self.mMapView addAnnotations:self.pointArray];
//    CLLocationCoordinate2D coor;
//    BMKPointAnnotation *poi=[self.pointArray objectAtIndex:0];
//    coor=poi.coordinate;
//    [self.mMapView setCenterCoordinate:coor];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
	static NSString *AnnotationViewID = @"annotationViewID";
	
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
	
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
	annotationView.canShowCallout = TRUE;
    return annotationView;
}

-(void)dealloc
{
    self.pointArray=nil;
    [super dealloc];
}

@end
