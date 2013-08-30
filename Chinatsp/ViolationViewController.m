//
//  ViolationViewController.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-27.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//
#define CityTag 101
#define QueryTag 102

#import "ViolationViewController.h"
#import "UIHelper.h"
#import "NetService.h"
#import "JSONKit.h"
#import "config.h"

@interface ViolationViewController ()

@end

@implementation ViolationViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"违章查询";
        self.hidesBottomBarWhenPushed=YES;
        array=[[NSArray alloc] initWithObjects:@"北京",@"上海",@"广州",@"深圳",@"重庆",@"哈尔滨",@"乌鲁木齐", nil];
        volatilearray=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initViews];
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    UIView *violationbg=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0-44.0+(iPhone5?88:0))];
    if(iPhone5)
    {
        violationbg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg-568h"]];
    }else
    {
        violationbg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    }
    [self.view addSubview:violationbg];
    [violationbg release];
    
    UIImageView *querybg=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-304.5)/2, 6.0, 304.5, 131.5)];
    querybg.userInteractionEnabled=YES;
    [querybg setImage:[UIImage imageNamed:@"query_bg"]];
    [violationbg addSubview:querybg];
    [querybg release];
    
    UILabel *citylabel=[[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 100.0, 25.0)];
    citylabel.text=@"选择城市";
    citylabel.textColor=[UIColor whiteColor];
    citylabel.backgroundColor=[UIColor clearColor];
    [querybg addSubview:citylabel];
    [citylabel release];
    
    UILabel *carNumlabel=[[UILabel alloc] initWithFrame:CGRectMake(10.0, citylabel.frame.origin.y+citylabel.frame.size.height+15, 100.0, 25.0)];
    carNumlabel.textColor=[UIColor whiteColor];
    carNumlabel.backgroundColor=[UIColor clearColor];
    carNumlabel.text=@"车牌号";
    [querybg addSubview:carNumlabel];
    [carNumlabel release];
    
    UILabel *enginelabel=[[UILabel alloc] initWithFrame:CGRectMake(10.0, carNumlabel.frame.size.height+carNumlabel.frame.origin.y+15, 100.0, 25.0)];
    enginelabel.text=@"发动机编号";
    enginelabel.textColor=[UIColor whiteColor];
    enginelabel.backgroundColor=[UIColor clearColor];
    [querybg addSubview:enginelabel];
    [enginelabel release];
    
    cityBtn=[[UIButton alloc] initWithFrame:CGRectMake(117.0, 10.0, 72.5, 27.0)];
    [cityBtn setBackgroundImage:[UIImage imageNamed:@"city_btn"] forState:UIControlStateNormal];
    [cityBtn setTitle:@"重庆" forState:UIControlStateNormal];
    cityBtn.tag=CityTag;
    cityBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [cityBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [querybg addSubview:cityBtn];
    [cityBtn release];
    
    carNumField1=[[UITextField alloc] initWithFrame:CGRectMake(115.0, 50.0,155.5, 26.0)];
    carNumField1.borderStyle=UITextBorderStyleRoundedRect;
    //carNumField1.background=[UIImage imageNamed:@"input_bg1"];
    carNumField1.text=@"B8W005";
    carNumField1.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    carNumField1.delegate=self;
    [querybg addSubview:carNumField1];
    [carNumField1 release];
    
//    carNumField2=[[UITextField alloc] initWithFrame:CGRectMake(145.0, 50.0,28.5, 26.0)];
//    carNumField2.borderStyle=UITextBorderStyleRoundedRect;
//    carNumField2.background=[UIImage imageNamed:@"input_bg1"];
//    carNumField2.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
//    carNumField2.delegate=self;
//    [querybg addSubview:carNumField2];
//    
//    carNumField3=[[UITextField alloc] initWithFrame:CGRectMake(178.0, 50.0,92.0,26.0)];
//    carNumField3.borderStyle=UITextBorderStyleRoundedRect;
//    carNumField3.background=[UIImage imageNamed:@"input_bg1"];
//    carNumField3.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
//    carNumField3.delegate=self;
//    [querybg addSubview:carNumField3];
    
    carEngineField=[[UITextField alloc] initWithFrame:CGRectMake(115.0,90.0, 157.5, 26.0)];
    carEngineField.borderStyle=UITextBorderStyleRoundedRect;
    carEngineField.background=[UIImage imageNamed:@"input_bg3"];
    carEngineField.text=@"LS5A2ADE1AA502552";
    carEngineField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    carEngineField.delegate=self;
    [querybg addSubview:carEngineField];
    [carEngineField release];
    
    UIButton *querybtn=[UIButton buttonWithType:UIButtonTypeCustom];
    querybtn.frame=CGRectMake(320.0-92.0-10.0, querybg.frame.size.height+querybg.frame.origin.y+6.0,92.0, 41.0);
    querybtn.tag=QueryTag;
    [querybtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [querybtn setImage:[UIImage imageNamed:@"query_btn"] forState:UIControlStateNormal];
    [self.view addSubview:querybtn];
    
    UIImageView *tabletitlebg=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-304.5)/2, querybtn.frame.origin.y+querybtn.frame.size.height+5.0, 304.5, 22.5)];
    [tabletitlebg setImage:[UIImage imageNamed:@"tabletitlebg"]];
    [self.view addSubview:tabletitlebg];
    [tabletitlebg release];
    
    UILabel *tabletitle=[[UILabel alloc] initWithFrame:CGRectMake(5.0,1.0,100.0, 20.0)];
    tabletitle.backgroundColor=[UIColor clearColor];
    tabletitle.text=@"违章信息:";
    tabletitle.font=[UIFont systemFontOfSize:14.0];
    tabletitle.textColor=[UIColor whiteColor];
    [tabletitlebg addSubview:tabletitle];
    [tabletitle release];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake((320.0-304.5)/2, tabletitlebg.frame.origin.y+tabletitlebg.frame.size.height, 304.0, 416.0-70.5-tabletitlebg.frame.origin.y-tabletitlebg.frame.size.height+(iPhone5?88:0)) style:UITableViewStylePlain];
    table.backgroundColor=[UIColor clearColor];
    table.dataSource=self;
    table.delegate=self;
    table.separatorStyle=NO;
    [self.view addSubview:table];
    [table release];

    custombar=[[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 560.0, 320.0, 50.0)];
    custombar.barStyle=UIBarStyleBlackTranslucent;
    [self.view addSubview:custombar];
    [custombar release];
    
    UIBarButtonItem *done=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hidePickView)];
    UIBarButtonItem *empty=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *save=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(selectCity)];
    custombar.items=[NSArray arrayWithObjects:done,empty,save, nil];
    [done release];
    [empty release];
    [save release];
    
    pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 610.0, 320.0, 162.0)];
    pickerView.showsSelectionIndicator=YES;
    pickerView.delegate=self;
    pickerView.dataSource=self;
    [self.view addSubview:pickerView];
    [pickerView release];
    
}

-(void)btnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)btnClick:(id)sender
{
    UIButton *button=(UIButton *)sender;
    if(button.tag==CityTag)
    {
        [carNumField1 resignFirstResponder];
        [carEngineField resignFirstResponder];
        //[self showPickView];
        [UIHelper showAlertview:@"目前只支持重庆的数据"];
    }
    else if (button.tag==QueryTag)
    {
        [carNumField1 resignFirstResponder];
        [carEngineField resignFirstResponder];
        self.carNum=carNumField1.text;
        self.carEngineNum=carEngineField.text;
        if([UIHelper stringIsEmptyOrIsNull:self.carNum])
        {
            [UIHelper showAlertview:@"请输入车牌号"];
            return;
        }
        if([UIHelper stringIsEmptyOrIsNull:self.carEngineNum])
        {
            [UIHelper showAlertview:@"请输入发动机号"];
            return;
        }
        [self createProgressDialog];
        [NSThread detachNewThreadSelector:@selector(getHost) toTarget:self withObject:nil];
    }
}

-(void)getHost
{
    NSData *hostdata=[[NetService singleHttpService] getHost];
    if(hostdata)
    {
        NSDictionary *nd=[hostdata objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            NSString *host=[[[nd objectForKey:@"resp_data"] objectForKey:@"0"] objectForKey:@"ap_host"];
            NSData *volatiledata=[[NetService singleHttpService] queryViolationList:host carNum:self.carNum carEngineNum:self.carEngineNum];
            if(volatiledata)
            {
                NSDictionary *arrnd=[volatiledata objectFromJSONData];
                [self performSelectorOnMainThread:@selector(getResult:) withObject:arrnd waitUntilDone:NO];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(getFailResult) withObject:nil waitUntilDone:NO];
            }
        }
        else
        {
            [self performSelectorOnMainThread:@selector(getFailResult) withObject:nil waitUntilDone:NO];
        }
    }
    else
    {
        [self performSelectorOnMainThread:@selector(getFailResult) withObject:nil waitUntilDone:NO];
    }
}

-(void)getResult:(NSDictionary *)arrnd
{
    [self closeProgressDialog];
    [volatilearray removeAllObjects];
    if([@"OK" isEqualToString:[arrnd objectForKey:@"resp_status"]])
    {
        if([@"" isEqualToString:[arrnd objectForKey:@"resp_data"]])
        {
            [UIHelper showAlertview:@"没有找到数据"];
        }else
        {
            NSArray *arr=[[arrnd objectForKey:@"resp_data"] allValues];
            [volatilearray setArray:arr];
            [table reloadData];
        }
    }else
    {
        [UIHelper showAlertview:@"获取数据失败"];
    }
    
}

-(void)getFailResult
{
    [self closeProgressDialog];
    [UIHelper showAlertview:@"获取信息失败"];
}

-(void)showPickView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    custombar.frame=CGRectMake(0.0, 178.0, 320.0, 50.0);
    pickerView.frame=CGRectMake(0.0, 228.0, 320.0, 162.0);
    [UIView commitAnimations];
}

-(void)hidePickView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    custombar.frame=CGRectMake(0.0, 560.0, 320.0, 50.0);
    pickerView.frame=CGRectMake(0.0, 610.0, 320.0, 162.0);
    [UIView commitAnimations];
}

-(void)selectCity
{
    [self hidePickView];
    UIButton *button=(UIButton *)[self.view viewWithTag:CityTag];
    [button setTitle:[array objectAtIndex:[pickerView selectedRowInComponent:0]] forState:UIControlStateNormal];
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0-44.0-70.0+(iPhone5?88:0))];
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [array count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [array objectAtIndex:row];
}

//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    UIButton *button=(UIButton *)[self.view viewWithTag:CityTag];
//    [button setTitle:[array objectAtIndex:row] forState:UIControlStateNormal];
//}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [volatilearray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentify];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify] autorelease];
    }
    for(UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    UIImageView *cellbg=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 304.5, 130.5)];
    cellbg.image=[UIImage imageNamed:@"table_item"];
    cell.backgroundView=cellbg;
    [cellbg release];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *nd=[volatilearray objectAtIndex:[indexPath row]];
    UILabel *datelabel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, 2.0, 300.0, 25.0)] autorelease];
    datelabel.numberOfLines=1;
    datelabel.textColor=[UIColor whiteColor];
    datelabel.text=[nd objectForKey:@"pec_date"];
    datelabel.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:datelabel];
    
    UILabel *addrlabel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, datelabel.frame.origin.y+datelabel.frame.size.height, 300.0, 25)] autorelease];
    addrlabel.numberOfLines=0;
    addrlabel.textColor=[UIColor whiteColor];
    addrlabel.text=[nd objectForKey:@"pec_address"];
    [addrlabel sizeToFit];
    addrlabel.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:addrlabel];
    
    UILabel *actionlabel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, addrlabel.frame.origin.y+addrlabel.frame.size.height, 300.0, 25.0)] autorelease];
    actionlabel.numberOfLines=0;
    actionlabel.text=[nd objectForKey:@"pec_action"];
    [actionlabel sizeToFit];
    actionlabel.textColor=[UIColor whiteColor];
    actionlabel.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:actionlabel];
    
    UILabel *disposelabel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, actionlabel.frame.origin.y+actionlabel.frame.size.height, 300.0, 25.0)] autorelease];
    disposelabel.numberOfLines=0;
    disposelabel.textColor=[UIColor whiteColor];
    disposelabel.text=[nd objectForKey:@"pec_dispose"];
    [disposelabel sizeToFit];
    disposelabel.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:disposelabel];
    
    UIButton *teltbn=[UIButton buttonWithType:UIButtonTypeCustom];
    teltbn.frame=CGRectMake(304.5-68.5-5.0, 98.0, 68.5, 28.0);
    [teltbn setImage:[UIImage imageNamed:@"dial_tel"] forState:UIControlStateNormal];
    [cell.contentView addSubview:teltbn];
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [carEngineField resignFirstResponder];
    [carNumField1 resignFirstResponder];
//    [carNumField2 resignFirstResponder];
//    [carNumField3 resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePickView];
}

-(void)dealloc
{
    [array release];
    array=nil;
    [volatilearray release];
    volatilearray=nil;
    self.carEngineNum=nil;
    self.carNum=nil;
    [super dealloc];
}

@end
