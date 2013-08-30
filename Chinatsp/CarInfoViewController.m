//
//  CarInfoViewController.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-25.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#define Vehicle_Brand @"vehicle_brand"
#define Vehicle_Type  @"vehicle_type"
#define Veh_Color   @"veh_color"
#define Engine_No  @"engine_no"
#define Frame_No  @"frame_no"
#define Veh_No   @"veh_no"

#import "CarInfoViewController.h"
#import "JSONKit.h"
#import "UIHelper.h"
#import "NetService.h"
#import "config.h"

@interface CarInfoViewController ()

@end

@implementation CarInfoViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"车辆信息";
        tableNd=[[NSMutableDictionary alloc] init];
        clickFlag=0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:(iPhone5?@"home_bg-568h":@"home_bg")]];
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(getCarInfoInThread) toTarget:self withObject:nil];
	// Do any additional setup after loading the view.
}

-(void)getCarInfoInThread
{
    NSData *data=[[NetService singleHttpService] getCarInfo];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        [self performSelectorOnMainThread:@selector(getResult:) withObject:nd waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(getFailed:) withObject:@"获取信息失败!" waitUntilDone:NO];
    }
}

-(void)getFailed:(NSString *)str
{
    [self closeProgressDialog];
    [UIHelper showAlertview:str];
}

-(void)getResult:(NSDictionary *)nd
{
    [self closeProgressDialog];
    if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
    {
        [tableNd setDictionary:[nd objectForKey:@"resp_data"]];
        NSLog(@"=====%@",tableNd);
        table=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0-44.0+(iPhone5?88:0)) style:UITableViewStyleGrouped];
        table.dataSource=self;
        table.delegate=self;
        table.backgroundView=nil;
        [self.view addSubview:table];
        [table release];
        
    }
    else
    {
        [UIHelper showAlertview:@"获取数据失败!"];
    }
}

-(void)getFailResult
{
    [self closeProgressDialog];
    [UIHelper showAlertview:@"获取数据失败!"];
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 416.0+(iPhone5?88:0))];
    bgview.backgroundColor=[UIColor blackColor];
    bgview.alpha=0.5;
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

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    for(UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.textLabel.text=nil;
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if([indexPath row]==0)
    {
        cell.textLabel.text=@"车系:";
        UILabel *carseries=[[[UILabel alloc] initWithFrame:CGRectMake(75.0, 2.0, 200.0, 40.0)] autorelease];
        carseries.backgroundColor=[UIColor clearColor];
        [carseries setText:[tableNd objectForKey:Vehicle_Brand]];
        [cell.contentView addSubview:carseries];
    }
    else if ([indexPath row]==1)
    {
        cell.textLabel.text=@"车型：";
        UILabel *carmodel=[[[UILabel alloc] initWithFrame:CGRectMake(75.0, 2.0, 200.0, 40.0)] autorelease];
        carmodel.backgroundColor=[UIColor clearColor];
        [carmodel setText:[tableNd objectForKey:Vehicle_Type]];
        [cell.contentView addSubview:carmodel];
    }
    else if ([indexPath row]==2)
    {
        cell.textLabel.text=@"车身颜色：";
        UILabel *carcolor=[[[UILabel alloc] initWithFrame:CGRectMake(95.0, 2.0, 180.0, 40.0)] autorelease];
        carcolor.backgroundColor=[UIColor clearColor];
        [carcolor setText:[tableNd objectForKey:Veh_Color]];
        [cell.contentView addSubview:carcolor];
    }
    else if ([indexPath row]==3)
    {
        cell.textLabel.text=@"发动机号：";
        UILabel *carengine=[[[UILabel alloc] initWithFrame:CGRectMake(95.0, 2.0, 180.0, 40.0)] autorelease];
        carengine.backgroundColor=[UIColor clearColor];
        [carengine setText:[tableNd objectForKey:Engine_No]];
        [cell.contentView addSubview:carengine];
    }
    else if ([indexPath row]==4)
    {
        cell.textLabel.text=@"车架号：";
        UILabel *carnum=[[[UILabel alloc] initWithFrame:CGRectMake(85.0, 2.0, 190.0, 40.0)] autorelease];
        carnum.backgroundColor=[UIColor clearColor];
        [carnum setText:[tableNd objectForKey:Frame_No]];
        [cell.contentView addSubview:carnum];
    }
    else if ([indexPath row]==5)
    {
        cell.textLabel.text=@"车牌号码：";
        UILabel *carlicence=[[[UILabel alloc] initWithFrame:CGRectMake(95.0, 2.0, 180.0, 40.0)] autorelease];
        carlicence.backgroundColor=[UIColor clearColor];
        [carlicence setText:[tableNd objectForKey:Veh_No]];
        [cell.contentView addSubview:carlicence];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath row]==0)
    {
        clickFlag=1;
        [self showUpdateAlertView:[tableNd objectForKey:Vehicle_Brand]];
    }
    else if([indexPath row]==1)
    {
        clickFlag=2;
        [self showUpdateAlertView:[tableNd objectForKey:Vehicle_Type]];
    }
    else if ([indexPath row]==2)
    {
        clickFlag=3;
        [self showUpdateAlertView:[tableNd objectForKey:Veh_Color]];
    }
    else if ([indexPath row]==3)
    {
        clickFlag=4;
        [self showUpdateAlertView:[tableNd objectForKey:Engine_No]];
    }
    else if ([indexPath row]==4)
    {
        clickFlag=5;
        [self showUpdateAlertView:[tableNd objectForKey:Frame_No]];
    }
    else if ([indexPath row]==5)
    {
        clickFlag=6;
        [self showUpdateAlertView:[tableNd objectForKey:Veh_No]];
    }
}

-(void)showUpdateAlertView:(NSString *)str
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入新值" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setText:str];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *tf=[alertView textFieldAtIndex:0];
    if(buttonIndex==1)
    {
        [self createProgressDialog];
        [NSThread detachNewThreadSelector:@selector(updateInThread:) toTarget:self withObject:tf.text];
    }
}

-(void)updateInThread:(NSString *)str
{
    NSData *data=nil;
    if(clickFlag==1)
    {
        data=[[NetService singleHttpService] updateCarInfo:str method:Vehicle_Brand];
    }
    else if (clickFlag==2)
    {
        data=[[NetService singleHttpService] updateCarInfo:str method:Vehicle_Type];
    }
    else if (clickFlag==3)
    {
        data=[[NetService singleHttpService] updateCarInfo:str method:Veh_Color];
    }
    else if (clickFlag==4)
    {
        data=[[NetService singleHttpService] updateCarInfo:str method:Engine_No];
    }
    else if (clickFlag==5)
    {
        data=[[NetService singleHttpService] updateCarInfo:str method:Frame_No];
    }
    else if (clickFlag==6)
    {
        data=[[NetService singleHttpService] updateCarInfo:str method:Veh_No];
    }
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            [self performSelectorOnMainThread:@selector(getUpdateResult:) withObject:str waitUntilDone:NO];
        }
        else
        {
            
            [self performSelectorOnMainThread:@selector(getFailed:) withObject:@"保存失败!" waitUntilDone:NO];
        }
        
    }
    else
    {
        [self performSelectorOnMainThread:@selector(getFailed:) withObject:@"保存失败!" waitUntilDone:NO];
    }
}

-(void)getUpdateResult:(NSString *)str
{
    [self closeProgressDialog];
    if(clickFlag==1)
    {
        [tableNd setValue:str forKey:Vehicle_Brand];
    }
    else if (clickFlag==2)
    {
        [tableNd setValue:str forKey:Vehicle_Type];
    }
    else if (clickFlag==3)
    {
        [tableNd setValue:str forKey:Veh_Color];
    }
    else if (clickFlag==4)
    {
        [tableNd setValue:str forKey:Engine_No];
    }
    else if (clickFlag==5)
    {
        [tableNd setValue:str forKey:Frame_No];
    }
    else if (clickFlag==6)
    {
        [tableNd setValue:str forKey:Veh_No];
    }
    [table reloadData];
}

-(void)dealloc
{
    [tableNd release];
    tableNd=nil;
    [super dealloc];
}

@end
