//
//  PoiListViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-23.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "PoiListViewController.h"
#import "BMapKit.h"
#import "ShowMapViewController.h"
#import "UIHelper.h"
#import "NetService.h"
#import "JSONKit.h"
#import "Collect.h"
#import "config.h"

@interface PoiListViewController ()

@end

@implementation PoiListViewController

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
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    self.title=self.title;
    [self initViews];
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    table=[[UITableView alloc] initWithFrame:CGRectMake((320.0-304.5)/2,0, 304.5, 460.0-44.0+(iPhone5?88:0)) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    table.separatorStyle=NO;
    table.backgroundColor=[UIColor clearColor];
    [self.view addSubview:table];
    [table release];
}

-(void)btnClick
{
    ShowMapViewController *showmap=[[ShowMapViewController alloc] init];
    showmap.pointArray=self.annoArray;
    [self.navigationController pushViewController:showmap animated:YES];
    [showmap release];
}

-(void)TelClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    BMKPoiInfo *info=[self.listArray objectAtIndex:btn.tag];
    NSLog(@"-----%@",info.phone);
    if(info.phone)
    {
        NSString *deviceType=[UIDevice currentDevice].model;
        if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"])
        {
            [UIHelper showAlertview:@"设备没有打电话功能"];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",info.phone]]];
        }
    }
    else
    {
        [UIHelper showAlertview:@"没有找到电话"];
    }
}

-(void)MapClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    BMKPoiInfo *info=[self.listArray objectAtIndex:btn.tag];
    BMKPointAnnotation* item = [[[BMKPointAnnotation alloc]init] autorelease];
    item.coordinate = info.pt;
    item.title = info.name;
    NSArray *array=[NSArray arrayWithObject:item];
    ShowMapViewController *showmap=[[ShowMapViewController alloc] init];
    showmap.pointArray=array;
    [self.navigationController pushViewController:showmap animated:YES];
    [showmap release];
}

-(void)CloudClick:(id)sender
{
    [self createProgressDialog];
    UIButton *btn=(UIButton *)sender;
    BMKPoiInfo *info=[self.listArray objectAtIndex:btn.tag];
    Collect *collect=[[Collect alloc] init];
    collect.title=info.address;
    collect.lat=info.pt.latitude;
    collect.lon=info.pt.longitude;
    [NSThread detachNewThreadSelector:@selector(iCloudyDataInsert:) toTarget:self withObject:collect];
    [collect release];
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

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0-44.0+(iPhone5?88:0))];
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
    progressdialog.center =bgview.center;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    for(UIView *subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    UIImageView *cellbg=[[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 304.5, 116.5)] autorelease];
    cellbg.userInteractionEnabled=YES;
    cellbg.image=[UIImage imageNamed:@"poi_bg"];
    [cell.contentView addSubview:cellbg];
    BMKPoiInfo *info=[self.listArray objectAtIndex:[indexPath row]];
    UILabel *title=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 300.0, 25.0)] autorelease];
    title.numberOfLines=1;
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    title.text=info.name;
    [cellbg addSubview:title];
    
    UILabel *addr=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, title.frame.size.height+title.frame.origin.y, 300.0, 20.0)] autorelease];
    addr.numberOfLines=1;
    addr.textColor=[UIColor whiteColor];
    addr.backgroundColor=[UIColor clearColor];
    if(info.address)
    {
        addr.text=[NSString stringWithFormat:@"地址：%@",info.address];
    }
    else
    {
        addr.text=@"地址：暂时没有";
    }
    addr.font=[UIFont systemFontOfSize:14.0];
    [cellbg addSubview:addr];
    
    UILabel *tel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, addr.frame.size.height+addr.frame.origin.y, 300.0, 20.0)] autorelease];
    tel.numberOfLines=1;
    tel.textColor=[UIColor whiteColor];
    tel.backgroundColor=[UIColor clearColor];
    if(info.phone)
    {
        tel.text=[NSString stringWithFormat:@"电话：%@",info.phone];
    }else
    {
        tel.text=@"电话：暂时没有";
    }
    tel.font=[UIFont systemFontOfSize:14.0];
    [cell.contentView addSubview:tel];
    
    UIButton *telbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    telbtn.frame=CGRectMake(20.0, tel.frame.size.height+tel.frame.origin.y+5.0, 80.0, 28.5);
    telbtn.tag=[indexPath row];
    [telbtn addTarget:self action:@selector(TelClick:) forControlEvents:UIControlEventTouchUpInside];
    [telbtn setImage:[UIImage imageNamed:@"poi_tel"] forState:UIControlStateNormal];
    [cellbg addSubview:telbtn];
    
    UIButton *mapbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    mapbtn.frame=CGRectMake(telbtn.frame.size.width+telbtn.frame.origin.x+10.0, tel.frame.size.height+tel.frame.origin.y+5.0, 80.0, 28.5);
    [mapbtn addTarget:self action:@selector(MapClick:) forControlEvents:UIControlEventTouchUpInside];
    mapbtn.tag=[indexPath row];
    [mapbtn setImage:[UIImage imageNamed:@"poi_map"] forState:UIControlStateNormal];
    [cellbg addSubview:mapbtn];
    
    UIButton *collectbtn=[[UIButton alloc] initWithFrame:CGRectMake(mapbtn.frame.size.width+mapbtn.frame.origin.x+10.0, tel.frame.size.height+tel.frame.origin.y+5.0, 80.0, 28.5)];
    collectbtn.tag=[indexPath row];
    [collectbtn addTarget:self action:@selector(CloudClick:) forControlEvents:UIControlEventTouchUpInside];
    [collectbtn setImage:[UIImage imageNamed:@"poi_collect"] forState:UIControlStateNormal];
    [cellbg addSubview:collectbtn];
    [collectbtn release];
    return cell;
}

-(void)dealloc
{
    self.listArray=nil;
    self.annoArray=nil;
    self.title=nil;
    [super dealloc];
}

@end
