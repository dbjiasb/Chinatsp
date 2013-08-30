//
//  AddActivityViewController.m
//  Chinatsp
//
//  Created by yuante on 13-5-13.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#define PublishTag 102
#define StartTimeTag 103
#define EndTimeTag 104

#import "AddActivityViewController.h"
#import "UIHelper.h"
#import "JSONKit.h"
#import "NetService.h"
#import "Blog.h"
#import "config.h"

@interface AddActivityViewController ()

@end

@implementation AddActivityViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title=@"添加活动";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.view.backgroundColor=[UIColor blackColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"活动" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    [self initViews];
}

-(void)initViews
{
//    table=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0-44.0+(iPhone5?88:0)) style:UITableViewStylePlain];
//    table.delegate=self;
//    table.dataSource=self;
//    table.backgroundColor=[UIColor clearColor];
//    table.separatorStyle=NO;
//    
//    [self.view addSubview:table];
//    [table release];
    
    titleField=[[UITextField alloc] initWithFrame:CGRectMake(115.0, 6.0, 190.0, 35.0)];
    titleField.borderStyle=UITextBorderStyleRoundedRect;
    titleField.textAlignment=UITextAlignmentLeft;
    titleField.delegate=self;
    titleField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
    startTimeField=[[UITextField alloc] initWithFrame:CGRectMake(115.0, 6.0, 190.0, 35.0)];
    startTimeField.borderStyle=UITextBorderStyleRoundedRect;
    startTimeField.textAlignment=UITextAlignmentLeft;
    startTimeField.delegate=self;
    startTimeField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
    startbtn=[[UIButton alloc] initWithFrame:CGRectMake(115.0, 6.0, 190.0, 35.0)];
    startbtn.tag=StartTimeTag;
    [startbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    endTimeField=[[UITextField alloc] initWithFrame:CGRectMake(115.0, 6.0, 190.0, 35.0)];
    endTimeField.borderStyle=UITextBorderStyleRoundedRect;
    endTimeField.textAlignment=UITextAlignmentLeft;
    endTimeField.delegate=self;
    endTimeField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
    endbtn=[[UIButton alloc] initWithFrame:CGRectMake(115.0, 6.0, 190.0, 35.0)];
    endbtn.tag=EndTimeTag;
    [endbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    desText=[[UITextView alloc] initWithFrame:CGRectMake(115.0, 6.0, 190.0, 115.0)];
    desText.textAlignment=UITextAlignmentLeft;
    desText.font=[UIFont systemFontOfSize:16.0];
    desText.delegate=self;
    
    senderField=[[UITextField alloc] initWithFrame:CGRectMake(115.0, 6.0, 190.0, 35.0)];
    senderField.borderStyle=UITextBorderStyleRoundedRect;
    senderField.textAlignment=UITextAlignmentLeft;
    senderField.delegate=self;
    senderField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
    phoneField=[[UITextField alloc] initWithFrame:CGRectMake(115.0,6.0, 190.0, 35.0)];
    phoneField.borderStyle=UITextBorderStyleRoundedRect;
    phoneField.delegate=self;
    phoneField.keyboardType=UIKeyboardTypeNumberPad;
    phoneField.textAlignment=UITextAlignmentLeft;
    phoneField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
    startAddrField=[[UITextField alloc] initWithFrame:CGRectMake(115.0,6.0, 190.0, 35.0)];
    startAddrField.borderStyle=UITextBorderStyleRoundedRect;
    startAddrField.textAlignment=UITextAlignmentLeft;
    startAddrField.delegate=self;
    startAddrField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
    endAddrField=[[UITextField alloc] initWithFrame:CGRectMake(115.0,6.0, 190.0, 35.0)];
    endAddrField.borderStyle=UITextBorderStyleRoundedRect;
    endAddrField.textAlignment=UITextAlignmentLeft;
    endAddrField.delegate=self;
    endAddrField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
//    customBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 710.0, 320.0, 50.0)];
//    customBar.barStyle=UIBarStyleBlackTranslucent;
//    [self.view addSubview:customBar];
//    [customBar release];
//    
//    UIBarButtonItem *done=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hidePickView)];
//    UIBarButtonItem *empty=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *save=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(selectPosition)];
//    customBar.items=[NSArray arrayWithObjects:done,empty,save, nil];
//    [done release];
//    [empty release];
//    [save release];
//    
//    picker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 760.0, 320.0, 162.0)];
//    [self.view addSubview:picker];
//    [picker release];
}

-(void)btnClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case PublishTag:
        {
            if([UIHelper stringIsEmptyOrIsNull:titleField.text])
            {
                [UIHelper showAlertview:@"请输入标题"];
                return;
            }
            if([UIHelper stringIsEmptyOrIsNull:startTimeField.text])
            {
                [UIHelper showAlertview:@"请输入开始时间"];
                return;
            }
            if([UIHelper stringIsEmptyOrIsNull:endTimeField.text])
            {
                [UIHelper showAlertview:@"请输入结束时间"];
                return;
            }
            if([UIHelper stringIsEmptyOrIsNull:desText.text])
            {
                [UIHelper showAlertview:@"请输入描述信息"];
                return;
            }
            if([UIHelper stringIsEmptyOrIsNull:senderField.text])
            {
                [UIHelper showAlertview:@"请输入发起人"];
                return;
            }
            if([UIHelper stringIsEmptyOrIsNull:phoneField.text])
            {
                [UIHelper showAlertview:@"请输入联系电话"];
                return;
            }
            if([UIHelper stringIsEmptyOrIsNull:startAddrField.text])
            {
                [UIHelper showAlertview:@"请输入出发地点"];
                return;
            }
            if([UIHelper stringIsEmptyOrIsNull:endAddrField.text])
            {
                [UIHelper showAlertview:@"请输入到达地点"];
                return;
            }
            Blog *blog=[[Blog alloc] init];
            blog.title=titleField.text;
            blog.time=[NSString stringWithFormat:@"%@,%@",startTimeField.text,endTimeField.text];
            blog.brief=desText.text;
            blog.name=senderField.text;
            blog.phone=phoneField.text;
            blog.from=[NSString stringWithFormat:@"%@,%@",startAddrField.text,endAddrField.text];
            [self createProgressDialog];
            [NSThread detachNewThreadSelector:@selector(insertBlogInThread:) toTarget:self withObject:blog];
        }
            break;
        case StartTimeTag:
            [self hideKeyBoard];
            [self showPickerView];
            selectTimeFlag=StartTimeTag;
            break;
        case EndTimeTag:
            [self hideKeyBoard];
            [self showPickerView];
            selectTimeFlag=EndTimeTag;
            break;
        default:
            break;
    }
}

-(void)btnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)insertBlogInThread:(Blog *)blog
{
    NSDate *date=[NSDate date];
    NSDateFormatter *dateformatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentdate=[dateformatter stringFromDate:date];
    NSData *data=[[NetService singleHttpService] insertBlog:blog time:currentdate type:@"2"];
    [self performSelectorOnMainThread:@selector(getInsertResult:) withObject:data waitUntilDone:NO];
}

-(void)getInsertResult:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([@"OK" isEqualToString:[nd objectForKey:@"resp_status"]])
        {
            [UIHelper showAlertview:@"发布成功"];
            [self dismissModalViewControllerAnimated:YES];
        }else
        {
            [UIHelper showAlertview:@"发布失败"];
        }
    }else
    {
        [UIHelper showAlertview:@"网络异常"];
    }
}

-(void)hideKeyBoard
{
    [titleField resignFirstResponder];
    [startTimeField resignFirstResponder];
    [endTimeField resignFirstResponder];
    [desText resignFirstResponder];
    [senderField resignFirstResponder];
    [phoneField resignFirstResponder];
    [startAddrField resignFirstResponder];
    [endAddrField resignFirstResponder];
}

-(void)showPickerView
{
    if(!customBar)
    {
        customBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 710.0, 320.0, 50.0)];
        customBar.barStyle=UIBarStyleBlackTranslucent;
        [self.view.window addSubview:customBar];
        [customBar release];
        
        UIBarButtonItem *done=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hidePickView)];
        UIBarButtonItem *empty=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *save=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(selectPosition)];
        customBar.items=[NSArray arrayWithObjects:done,empty,save, nil];
        [done release];
        [empty release];
        [save release];
    }
    if(!picker)
    {
        picker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 760.0, 320.0, 162.0)];
        [self.view.window addSubview:picker];
        [picker release];
    }
    [UIView animateWithDuration:0.3 animations:^{
        customBar.frame=CGRectMake(0.0, 480.0+(iPhone5?88:0)-162.0-50.0, 320.0, 50.0);
        picker.frame=CGRectMake(0.0, 480.0+(iPhone5?88:0)-162.0, 320.0, 162.0);
    }];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    customBar.frame=CGRectMake(0.0, 204.0+(iPhone5?88:0), 320.0, 50.0);
//    picker.frame=CGRectMake(0.0, 254.0+(iPhone5?88:0), 320.0, 162.0);
//    [UIView commitAnimations];
}

-(void)hidePickView
{
    [UIView animateWithDuration:0.3 animations:^{
        customBar.frame=CGRectMake(0.0, 710.0, 320.0, 50.0);
        picker.frame=CGRectMake(0.0, 760.0, 320.0, 162.0);
    } completion:^(BOOL finished) {
//        [customBar removeFromSuperview];
//        [picker removeFromSuperview];
    }];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    customBar.frame=CGRectMake(0.0, 710.0, 320.0, 50.0);
//    picker.frame=CGRectMake(0.0, 760.0, 320.0, 162.0);
//    [UIView commitAnimations];
}

-(void)selectPosition
{
    [self hidePickView];
    NSDate *chooseDate=picker.date;
    NSDateFormatter *tempDate = [[NSDateFormatter alloc]init];
    [tempDate setLocale:[NSLocale currentLocale]];
    [tempDate setDateFormat:@"yyyy-MM-dd HH:mm:00"];//24小时制
    NSString *tempDatestring = [tempDate stringFromDate:chooseDate];
    [tempDate release];
    if(selectTimeFlag==StartTimeTag)
    {
        startTimeField.text=tempDatestring;
    }else
    {
        endTimeField.text=tempDatestring;
    }
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0-44.0+(iPhone5?88:0))];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]==3)
    {
        return 121.0;
    }
    return 41.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    for(UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.text = nil;
    switch ([indexPath row]) {
        case 0:
            cell.textLabel.text=@"活动标题：";
            [cell.contentView addSubview:titleField];
            break;
        case 1:
            cell.textLabel.text=@"开始时间：";
            [cell.contentView addSubview:startTimeField];
            [cell.contentView addSubview:startbtn];
            break;
        case 2:
            cell.textLabel.text=@"结束时间：";
            [cell.contentView addSubview:endTimeField];
            [cell.contentView addSubview:endbtn];
            break;
        case 3:
            cell.textLabel.text=@"活动简述：";
            [cell.contentView addSubview:desText];
            break;
        case 4:
            cell.textLabel.text=@"发起人：";
            [cell.contentView addSubview:senderField];
            break;
        case 5:
            cell.textLabel.text=@"联系电话：";
            [cell.contentView addSubview:phoneField];
            break;
        case 6:
            cell.textLabel.text=@"出发地点：";
            [cell.contentView addSubview:startAddrField];
            break;
        case 7:
            cell.textLabel.text=@"到达地点：";
        	[cell.contentView addSubview:endAddrField];
            break;
        case 8:
        {
            UIButton *publishbtn=[UIButton buttonWithType:UIButtonTypeCustom];
            publishbtn.frame=CGRectMake(320.0-110.0, 6.0, 93.0, 38.0);
            publishbtn.tag=PublishTag;
            [publishbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [publishbtn setImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
            [cell.contentView addSubview:publishbtn];
            
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePickView];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self hidePickView];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyBoard];
    [self hidePickView];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [self hideKeyBoard];
        [self hidePickView];
        return NO;
    }
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [self resignFirstResponder];
        return NO;
    }
    if(range.location>=130)
    {
        return NO;
    }
    return YES;
}

-(void)dealloc
{
    [customBar removeFromSuperview];
    [picker removeFromSuperview];
    [titleField release];
    titleField=nil;
    [startTimeField release];
    startTimeField=nil;
    [startbtn release];
    startbtn=nil;
    [endTimeField release];
    endTimeField=nil;
    [endbtn release];
    endbtn=nil;
    [desText release];
    desText=nil;
    [senderField release];
    senderField=nil;
    [phoneField release];
    phoneField=nil;
    [startAddrField release];
    startAddrField=nil;
    [endAddrField release];
    endAddrField=nil;
    [super dealloc];
}

@end
