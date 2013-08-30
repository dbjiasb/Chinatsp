//
//  WeatherViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-15.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "WeatherViewController.h"
#import "UIHelper.h"
#import "NetService.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "UIImageView+WebCache.h"
#import "JSONKit.h"
#import "config.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
        self.title=@"天气";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStyleBordered target:self action:@selector(cityClick)] autorelease];
    [self initViews];
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(getWeatherInThread) toTarget:self withObject:nil];
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    UIImageView *topbg=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-304.5)/2, 6.0, 304.5, 30.0)];
    topbg.image=[UIImage imageNamed:@"weather_top"];
    topbg.userInteractionEnabled=YES;
    [self.view addSubview:topbg];
    [topbg release];
    
    timelabel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, (30.0-25.0)/2, 150.0, 25.0)];
    timelabel.textColor=[UIColor whiteColor];
    timelabel.backgroundColor=[UIColor clearColor];
    [topbg addSubview:timelabel];
    [timelabel release];
    
    UIImageView *middlebg=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-304.5)/2, topbg.frame.size.height+topbg.frame.origin.y, 304.4, 71.5)];
    middlebg.image=[UIImage imageNamed:@"weather_middle"];
    middlebg.userInteractionEnabled=YES;
    [self.view addSubview:middlebg];
    [middlebg release];
    
    templabel=[[UILabel alloc] initWithFrame:CGRectMake(15.0, (71.5-40.0)/2, 40.0, 40.0)];
    templabel.textColor=[UIColor whiteColor];
    templabel.backgroundColor=[UIColor clearColor];
    [middlebg addSubview:templabel];
    [templabel release];
    
    weatherlabel=[[UILabel alloc] initWithFrame:CGRectMake(templabel.frame.size.width+templabel.frame.origin.x+15.0, 10.0, 140.0, 25.0)];
    weatherlabel.textColor=[UIColor whiteColor];
    weatherlabel.backgroundColor=[UIColor clearColor];
    [middlebg addSubview:weatherlabel];
    [weatherlabel release];
    
    windlable=[[UILabel alloc] initWithFrame:CGRectMake(templabel.frame.size.width+templabel.frame.origin.x+15.0, weatherlabel.frame.size.height+weatherlabel.frame.origin.y, 134.0, 25.0)];
    windlable.textColor=[UIColor whiteColor];
    windlable.backgroundColor=[UIColor clearColor];
    [middlebg addSubview:windlable];
    [windlable release];
    
    weathericon=[[UIImageView alloc] initWithFrame:CGRectMake(304.5-60.0-10.0, (71.5-60.0)/2, 60.0, 60.0)];
    [middlebg addSubview:weathericon];
    [weathericon release];
    
    UIImageView *bottombg=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-304.5)/2,middlebg.frame.origin.y+middlebg.frame.size.height, 304.5, 30.0)];
    bottombg.image=[UIImage imageNamed:@"weather_bottom"];
    bottombg.userInteractionEnabled=YES;
    [self.view addSubview:bottombg];
    [bottombg release];
    
    humiditylabel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, 2.5, 120.0, 25.0)];
    humiditylabel.textColor=[UIColor whiteColor];
    humiditylabel.backgroundColor=[UIColor clearColor];
    humiditylabel.font=[UIFont systemFontOfSize:14.0];
    [bottombg addSubview:humiditylabel];
    [humiditylabel release];
    
    publishitime=[[UILabel alloc] initWithFrame:CGRectMake(humiditylabel.frame.size.width+humiditylabel.frame.origin.x, 2.5, 175.0, 25.0)];
    publishitime.font=[UIFont systemFontOfSize:14.0];
    publishitime.textColor=[UIColor whiteColor];
    publishitime.backgroundColor=[UIColor clearColor];
    [bottombg addSubview:publishitime];
    [publishitime release];
    
    UIImageView *infotop=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-304.5)/2,bottombg.frame.origin.y+bottombg.frame.size.height+4.0, 304.5, 30.0)];
    infotop.image=[UIImage imageNamed:@"info_top"];
    [self.view addSubview:infotop];
    [infotop release];
    
    UIImageView *infomiddle=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-304.5)/2,infotop.frame.size.height+infotop.frame.origin.y, 304.5, 30.0)];
    infomiddle.image=[UIImage imageNamed:@"info_middle"];
    [self.view addSubview:infomiddle];
    [infomiddle release];
    
    UIImageView *infomiddle1=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-304.5)/2,infomiddle.frame.size.height+infomiddle.frame.origin.y, 304.5, 30.0)];
    infomiddle1.image=[UIImage imageNamed:@"info_middle"];
    [self.view addSubview:infomiddle1];
    [infomiddle1 release];
    
    UIImageView *infobottom=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-304.5)/2,infomiddle1.frame.size.height+infomiddle1.frame.origin.y, 304.5, 30.0)];
    infobottom.image=[UIImage imageNamed:@"weather_bottom"];
    [self.view addSubview:infobottom];
    [infobottom release];

    UIImageView *weatherlistbg=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-305)/2, infobottom.frame.size.height+infobottom.frame.origin.y+3.0, 305.0, 78.5)];
    weatherlistbg.image=[UIImage imageNamed:@"three_grid"];
    [self.view addSubview:weatherlistbg];
    [weatherlistbg release];
    
    carconditonlabel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, (30.0-25.0)/2, 280.0, 25.0)];
    carconditonlabel.textColor=[UIColor whiteColor];
    carconditonlabel.backgroundColor=[UIColor clearColor];
    [infotop addSubview:carconditonlabel];
    [carconditonlabel release];
    
    clothconditionlabel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, (30.0-25.0)/2, 280.0, 25.0)];
    clothconditionlabel.textColor=[UIColor whiteColor];
    clothconditionlabel.backgroundColor=[UIColor clearColor];
    [infomiddle addSubview:clothconditionlabel];
    [clothconditionlabel release];
    
    raylable=[[UILabel alloc] initWithFrame:CGRectMake(5.0, (30.0-25.0)/2, 280.0, 25.0)];
    raylable.textColor=[UIColor whiteColor];
    raylable.backgroundColor=[UIColor clearColor];
    [infomiddle1 addSubview:raylable];
    [raylable release];
    
    airconditionlabel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, (30.0-25.0)/2, 280.0, 25.0)];
    airconditionlabel.textColor=[UIColor whiteColor];
    airconditionlabel.backgroundColor=[UIColor clearColor];
    [infobottom addSubview:airconditionlabel];
    [airconditionlabel release];
    
    list_today=[[UILabel alloc] initWithFrame:CGRectMake(6.0, 7.0, 90.0, 20.0)];
    list_today.textColor=[UIColor whiteColor];
    list_today.backgroundColor=[UIColor clearColor];
    list_today.textAlignment=NSTextAlignmentCenter;
    [weatherlistbg addSubview:list_today];
    [list_today release];
    
    list_condition1=[[UILabel alloc] initWithFrame:CGRectMake(6.0, list_today.frame.size.height+list_today.frame.origin.y,90.0,20.0)];
    list_condition1.textColor=[UIColor whiteColor];
    list_condition1.backgroundColor=[UIColor clearColor];
    list_condition1.textAlignment= NSTextAlignmentCenter;
    [weatherlistbg addSubview:list_condition1];
    [list_condition1 release];
    
    list_temp1=[[UILabel alloc] initWithFrame:CGRectMake(6.0, list_condition1.frame.origin.y+list_condition1.frame.size.height, 90.0, 20.0)];
    list_temp1.textColor=[UIColor whiteColor];
    list_temp1.backgroundColor=[UIColor clearColor];
    list_temp1.font=[UIFont systemFontOfSize:14.0];
    list_temp1.textAlignment= NSTextAlignmentCenter;
    [weatherlistbg addSubview:list_temp1];
    [list_temp1 release];
    
    list_tommrroy=[[UILabel alloc] initWithFrame:CGRectMake(list_condition1.frame.origin.x+list_condition1.frame.size.width+ 11.0, 7.0, 90.0, 20.0)];
    list_tommrroy.textColor=[UIColor whiteColor];
    list_tommrroy.backgroundColor=[UIColor clearColor];
    list_tommrroy.textAlignment=NSTextAlignmentCenter;
    [weatherlistbg addSubview:list_tommrroy];
    [list_tommrroy release];
    
    list_condition2=[[UILabel alloc] initWithFrame:CGRectMake(list_condition1.frame.origin.x+list_condition1.frame.size.width+ 11.0, list_tommrroy.frame.size.height+list_tommrroy.frame.origin.y,90.0,20.0)];
    list_condition2.textColor=[UIColor whiteColor];
    list_condition2.backgroundColor=[UIColor clearColor];
    list_condition2.textAlignment= NSTextAlignmentCenter;
    [weatherlistbg addSubview:list_condition2];
    [list_condition2 release];
    
    list_temp2=[[UILabel alloc] initWithFrame:CGRectMake(list_condition1.frame.origin.x+list_condition1.frame.size.width+ 11.0, list_condition2.frame.origin.y+list_condition2.frame.size.height, 90.0, 20.0)];
    list_temp2.textColor=[UIColor whiteColor];
    list_temp2.backgroundColor=[UIColor clearColor];
    list_temp2.font=[UIFont systemFontOfSize:14.0];
    list_temp2.textAlignment= NSTextAlignmentCenter;
    [weatherlistbg addSubview:list_temp2];
    [list_temp2 release];
    
    list_aftertommrroy=[[UILabel alloc] initWithFrame:CGRectMake(list_condition2.frame.origin.x+list_condition2.frame.size.width+ 11.0, 7.0, 90.0, 20.0)];
    list_aftertommrroy.textColor=[UIColor whiteColor];
    list_aftertommrroy.backgroundColor=[UIColor clearColor];
    list_aftertommrroy.textAlignment=NSTextAlignmentCenter;
    [weatherlistbg addSubview:list_aftertommrroy];
    [list_aftertommrroy release];
    
    list_condition3=[[UILabel alloc] initWithFrame:CGRectMake(list_condition2.frame.origin.x+list_condition2.frame.size.width+ 11.0,list_aftertommrroy.frame.origin.y+list_aftertommrroy.frame.size.height,90.0,20.0)];
    list_condition3.textColor=[UIColor whiteColor];
    list_condition3.backgroundColor=[UIColor clearColor];
    list_condition3.textAlignment= NSTextAlignmentCenter;
    [weatherlistbg addSubview:list_condition3];
    [list_condition3 release];
    
    list_temp3=[[UILabel alloc] initWithFrame:CGRectMake(list_condition2.frame.origin.x+list_condition2.frame.size.width+ 11.0, list_condition3.frame.origin.y+list_condition3.frame.size.height, 90.0, 20.0)];
    list_temp3.textColor=[UIColor whiteColor];
    list_temp3.backgroundColor=[UIColor clearColor];
    list_temp3.font=[UIFont systemFontOfSize:14.0];
    list_temp3.textAlignment= NSTextAlignmentCenter;
    [weatherlistbg addSubview:list_temp3];
    [list_temp3 release];
}

-(void)btnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)cityClick
{
    [UIHelper showAlertview:@"目前只支持北京城市"];
}

-(void)getWeatherInThread
{
    NSData *data=[[NetService singleHttpService] getWeatherInfo];
    [self performSelectorOnMainThread:@selector(getResult:) withObject:data waitUntilDone:NO];
}

-(void)getResult:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSMutableDictionary *todayNd=[[NSMutableDictionary alloc] init];
        NSMutableDictionary *tomNd=[[NSMutableDictionary alloc] init];
        NSMutableDictionary *afterNd=[[NSMutableDictionary alloc] init];
        DDXMLDocument *doc=[[DDXMLDocument alloc] initWithData:data options:0 error:nil];
        NSArray *toadyarray=[doc nodesForXPath:@"//today_conditions" error:nil];
        NSArray *tomarray=[doc nodesForXPath:@"//tomorrow_conditions" error:nil];
        NSArray *aftertomarray=[doc nodesForXPath:@"//after_tomorrow_conditions" error:nil];
        for (DDXMLElement *recode in toadyarray){
            DDXMLElement *coelement=[recode elementForName:@"condition"];
            if(coelement)
            {
                [todayNd setObject:[coelement attributeForName:@"data"].stringValue forKey:@"condition"];
                [todayNd setObject:[coelement attributeForName:@"icon_uri"].stringValue forKey:@"icon_uri"];
            }
            DDXMLElement *tmelement=[recode elementForName:@"temp_c"];
            if(tmelement)
            {
                [todayNd setObject:[tmelement attributeForName:@"low"].stringValue forKey:@"low"];
                [todayNd setObject:[tmelement attributeForName:@"high"].stringValue forKey:@"high"];
                [todayNd setObject:[tmelement attributeForName:@"now"].stringValue forKey:@"now"];
            }
            DDXMLElement *fdelement=[recode elementForName:@"forecast_date"];
            if(fdelement)
            {
                [todayNd setObject:[fdelement attributeForName:@"data"].stringValue forKey:@"forecast_date"];
            }
            DDXMLElement *cdelement=[recode elementForName:@"current_date_time"];
            if(cdelement)
            {
                [todayNd setObject:[cdelement attributeForName:@"data"].stringValue forKey:@"current_date_time"];
            }
            DDXMLElement *hmelement=[recode elementForName:@"humidity"];
            if(hmelement)
            {
                [todayNd setObject:[hmelement attributeForName:@"data"].stringValue forKey:@"humidity"];
            }
            DDXMLElement *wdelement=[recode elementForName:@"wind_condition"];
            if(wdelement)
            {
                [todayNd setObject:[wdelement attributeForName:@"direction"].stringValue forKey:@"direction"];
                [todayNd setObject:[wdelement attributeForName:@"power"].stringValue forKey:@"power"];
            }
            DDXMLElement *wcelement=[recode elementForName:@"washcar_condition"];
            if(wcelement)
            {
                [todayNd setObject:[wcelement attributeForName:@"data"].stringValue forKey:@"washcar_condition"];
                [todayNd setObject:[wcelement attributeForName:@"desc"].stringValue forKey:@"desc"];
            }
        }
        for (DDXMLElement *recode in tomarray){
            DDXMLElement *coelement=[recode elementForName:@"condition"];
            if(coelement)
            {
                [tomNd setObject:[coelement attributeForName:@"data"].stringValue forKey:@"condition"];
                [tomNd setObject:[coelement attributeForName:@"icon_uri"].stringValue forKey:@"icon_uri"];
            }
            DDXMLElement *tmelement=[recode elementForName:@"temp_c"];
            if(tmelement)
            {
                [tomNd setObject:[tmelement attributeForName:@"low"].stringValue forKey:@"low"];
                [tomNd setObject:[tmelement attributeForName:@"high"].stringValue forKey:@"high"];
            }
            DDXMLElement *wdelement=[recode elementForName:@"wind_condition"];
            if(wdelement)
            {
                [todayNd setObject:[wdelement attributeForName:@"direction"].stringValue forKey:@"direction"];
                [todayNd setObject:[wdelement attributeForName:@"power"].stringValue forKey:@"power"];
            }
        }
        for (DDXMLElement *recode in aftertomarray){
            DDXMLElement *coelement=[recode elementForName:@"condition"];
            if(coelement)
            {
                [afterNd setObject:[coelement attributeForName:@"data"].stringValue forKey:@"condition"];
                [afterNd setObject:[coelement attributeForName:@"icon_uri"].stringValue forKey:@"icon_uri"];
            }
            DDXMLElement *tmelement=[recode elementForName:@"temp_c"];
            if(tmelement)
            {
                [afterNd setObject:[tmelement attributeForName:@"low"].stringValue forKey:@"low"];
                [afterNd setObject:[tmelement attributeForName:@"high"].stringValue forKey:@"high"];
            }
            DDXMLElement *wdelement=[recode elementForName:@"wind_condition"];
            if(wdelement)
            {
                [afterNd setObject:[wdelement attributeForName:@"direction"].stringValue forKey:@"direction"];
                [afterNd setObject:[wdelement attributeForName:@"power"].stringValue forKey:@"power"];
            }
        }
        timelabel.text=[todayNd objectForKey:@"forecast_date"];
        templabel.text=[todayNd objectForKey:@"now"];
        weatherlabel.text=[todayNd objectForKey:@"condition"];
        windlable.text=[todayNd objectForKey:@"direction"];
        humiditylabel.text=[@"相对湿度:" stringByAppendingString:[todayNd objectForKey:@"humidity"]];
        publishitime.text=[[todayNd objectForKey:@"current_date_time"] stringByAppendingString:@" 发布"];
        [weathericon setImageWithURL:[NSURL URLWithString:[todayNd objectForKey:@"icon_uri"]] placeholderImage:[UIImage imageNamed:@""]];
        list_condition1.text=[todayNd objectForKey:@"condition"];
        NSString *temp1=[[todayNd objectForKey:@"low"] stringByAppendingString:@"－"];
        list_temp1.text=[temp1 stringByAppendingString:[todayNd objectForKey:@"high"]];
        
        list_condition2.text=[tomNd objectForKey:@"condition"];
        NSString *temp2=[[tomNd objectForKey:@"low"] stringByAppendingString:@"－"];
        list_temp2.text=[temp2 stringByAppendingString:[tomNd objectForKey:@"high"]];
        
        list_condition3.text=[afterNd objectForKey:@"condition"];
        NSString *temp3=[[afterNd objectForKey:@"low"] stringByAppendingString:@"－"];
        list_temp3.text=[temp3 stringByAppendingString:[afterNd objectForKey:@"high"]];
        carconditonlabel.text=@"汽车指数：非常适宜";
        clothconditionlabel.text=@"穿衣指数：适合穿夹衣类";
        raylable.text=@"紫外线：中等";
        airconditionlabel.text=@"空气污染：中等";
        list_today.text=@"今天";
        list_tommrroy.text=@"明天";
        list_aftertommrroy.text=@"后天";
        [doc release];
        [todayNd release];
        [tomNd release];
        [afterNd release];
    }else
    {
        [UIHelper showAlertview:@"网络异常"];
    }
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0+(iPhone5?88:0)-70.5-44.0)];
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
