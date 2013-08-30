//
//  AddBlogViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-24.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//


#import "AddBlogViewController.h"
#import "NetService.h"
#import "Blog.h"
#import "UIHelper.h"
#import "JSONKit.h"
#import "config.h"

@interface AddBlogViewController ()

@end

@implementation AddBlogViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"添加博客";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.view.backgroundColor=[UIColor blackColor];
    [self initViews];
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    UILabel *contentlabel=[[UILabel alloc] initWithFrame:CGRectMake(10.0, 6.0, 100.0, 25.0)];
    contentlabel.textColor=[UIColor whiteColor];
    contentlabel.backgroundColor=[UIColor clearColor];
    contentlabel.text=@"博客内容";
    [self.view addSubview:contentlabel];
    [contentlabel release];
    
    contentInput=[[UITextView alloc] initWithFrame:CGRectMake(10.0,contentlabel.frame.size.height+contentlabel.frame.origin.y,300.0, 120.0)];
    contentInput.font=[UIFont systemFontOfSize:16.0];
    contentInput.backgroundColor=[UIColor whiteColor];
    contentInput.delegate=self;
    [self.view addSubview:contentInput];
    [contentInput release];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(300.0-93.0, contentInput.frame.origin.y+contentInput.frame.size.height+10.0, 93.0, 38.0);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

-(void)btnClick:(id)sender
{
    if([UIHelper stringIsEmptyOrIsNull:contentInput.text])
    {
        [UIHelper showAlertview:@"请输入内容"];
        return;
    }
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(insertBlogInThread:) toTarget:self withObject:contentInput.text];

}

-(void)insertBlogInThread:(NSString *)content
{
    NSDate *date=[NSDate date];
    NSDateFormatter *dateformatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentdate=[dateformatter stringFromDate:date];
        NSLog(@"=====%@",currentdate);
    Blog *blog=[[Blog alloc] init];
    blog.brief=content;
    NSData *data=[[NetService singleHttpService] insertBlog:blog time:currentdate type:@"1"];
    [blog release];
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
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [UIHelper showAlertview:@"发布失败"];
        }
    }else
    {
        [UIHelper showAlertview:@"网络异常"];
    }
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0-44.0-70.0+(iPhone5?88:0))];
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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
    [super dealloc];
}

@end
