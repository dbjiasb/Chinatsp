//
//  UserInfoViewController.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-25.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#define Mobliekey  @"mobile_phone"
#define Emailkey  @"email"
#define Namekey  @"real_name"

#import "UserInfoViewController.h"
#import "NetService.h"
#import "UIHelper.h"
#import "JSONKit.h"
#import "config.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"个人信息";
        tableNd=[[NSMutableDictionary alloc] init];
        clickFlag=0;//1是点击名字，2是点击电话，3是点击邮箱
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:(iPhone5?@"home_bg-568h":@"home_bg")]];
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(getUserInfoInThread) toTarget:self withObject:nil];
	// Do any additional setup after loading the view.
}

-(void)getUserInfoInThread
{
    NSData *data=[[NetService singleHttpService] getUserInfo];
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

-(void)getResult:(NSDictionary *)nd
{
    [self closeProgressDialog];
    if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
    {
        NSDictionary *prond=[[nd objectForKey:@"resp_data"] objectForKey:@"protected"];
        [tableNd setDictionary:prond];
        table=[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0, 320.0, 416.0+(iPhone5?88:0)) style:UITableViewStyleGrouped];
        table.dataSource=self;
        table.delegate=self;
        table.backgroundView=nil;
        [self.view addSubview:table];
        [table release];
    }else
    {
        [UIHelper showAlertview:@"获取信息失败!"];
    }
}

-(void)getFailed:(NSString *)str
{
    [self closeProgressDialog];
    [UIHelper showAlertview:str];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else if (section==1)
    {
        return 2;
    }
    return 1;
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if([indexPath section]==0)
    {
        cell.textLabel.text=@"用户名:";
        UILabel *nametxt=[[[UILabel alloc] initWithFrame:CGRectMake(75.0, 2.0, 200.0, 40.0)] autorelease];
        nametxt.backgroundColor=[UIColor clearColor];
        [nametxt setText:[tableNd objectForKey:Namekey]];
        [cell.contentView addSubview:nametxt];
    }
    else if ([indexPath section]==1)
    {
        if([indexPath row]==0)
        {
            cell.textLabel.text=@"电话:";
            UILabel *mobiletxt=[[[UILabel alloc] initWithFrame:CGRectMake(65.0, 2.0, 200.0, 40.0)] autorelease];
            [mobiletxt setText:[tableNd objectForKey:Mobliekey]];
            mobiletxt.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:mobiletxt];
        }
        else if ([indexPath row]==1)
        {
            cell.textLabel.text=@"E-mail:";
            UILabel *emailtxt=[[[UILabel alloc] initWithFrame:CGRectMake(70.0, 2.0, 200.0, 40.0)] autorelease];
            [emailtxt setText:[tableNd objectForKey:Emailkey]];
            emailtxt.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:emailtxt];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath section]==0)
    {
        clickFlag=1;
        [self showUpdateAlertView:[tableNd objectForKey:Namekey]];
    }else if ([indexPath section]==1)
    {
     	if([indexPath row]==0)
        {
            clickFlag=2;
            [self showUpdateAlertView:[tableNd objectForKey:Mobliekey]];
        }
        else if ([indexPath row]==1)
        {
            clickFlag=3;
            [self showUpdateAlertView:[tableNd objectForKey:Emailkey]];
        }
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
        data=[[NetService singleHttpService] updateUserInfo:str method:Namekey];
    }
    else if (clickFlag==2)
    {
        data=[[NetService singleHttpService] updateUserInfo:str method:Mobliekey];
    }
    else if (clickFlag==3)
    {
        data=[[NetService singleHttpService] updateUserInfo:str method:Emailkey];
    }
    
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        NSLog(@"-----%@",nd);
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
        [tableNd setValue:str forKey:Namekey];
    }
    else if (clickFlag==2)
    {
        [tableNd setValue:str forKey:Mobliekey];
    }
    else if (clickFlag==3)
    {
        [tableNd setValue:str forKey:Emailkey];
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
