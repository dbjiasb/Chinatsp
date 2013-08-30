//
//  LoginViewController.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "LoginViewController.h"
#import "UIHelper.h"
#import "NetService.h"
#import "JSONKit.h"
#import "MyDefaults.h"
#import "config.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"登陆";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initViews];
    
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backClick)] autorelease];
    self.view.backgroundColor=[UIColor blackColor];
    
    UIImageView *loginimg=[[UIImageView alloc] initWithFrame:CGRectMake((320.0-180.5)/2,40.0, 180.5, 180.5)];
    loginimg.image=[UIImage imageNamed:@"login_img"];
    [self.view addSubview:loginimg];
    [loginimg release];
    
    nameField=[[UITextField alloc] initWithFrame:CGRectMake(10.0, loginimg.frame.size.height+loginimg.frame.origin.y+10.0, 300.0, 45.0)];
    nameField.borderStyle=UITextBorderStyleRoundedRect;
    nameField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    nameField.placeholder=@"请输入帐号";
    nameField.delegate=self;
    nameField.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:nameField];
    [nameField release];
     
     passwordField=[[UITextField alloc] initWithFrame:CGRectMake(10.0, nameField.frame.origin.y+nameField.frame.size.height+10.0, 300.0, 45.0)];
     passwordField.borderStyle=UITextBorderStyleRoundedRect;
     passwordField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
     [passwordField setSecureTextEntry:YES];
     passwordField.delegate=self;
     passwordField.placeholder=@"请输入密码";
     passwordField.returnKeyType=UIReturnKeyDone;
     [self.view addSubview:passwordField];
    [passwordField release];
    
    UIButton *loginbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginbtn.frame=CGRectMake(320.0-91.0-20.0, passwordField.frame.origin.y+passwordField.frame.size.height+10, 91.0, 40.0);
    [loginbtn setImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [loginbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
}

-(void)btnClick:(id)sender
{
    [self login];
}

-(void)backClick
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0+(iPhone5?88:0))];
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

-(void)login
{
//    Class nc=NSClassFromString(@"nc");
//    NSLog(@"=====%@",[nc share])
    self.username=nameField.text;
    self.pwd=passwordField.text;
    if([UIHelper stringIsEmptyOrIsNull:self.username])
    {
        [UIHelper showAlertview:@"请输入用户名"];
        return;
    }
    if([UIHelper stringIsEmptyOrIsNull:self.pwd])
    {
        [UIHelper showAlertview:@"请输入密码"];
        return;
    }
    [self resumeView];
    [self createProgressDialog];
    [nameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [NSThread detachNewThreadSelector:@selector(loginInThread) toTarget:self withObject:nil];
}

-(void)loginInThread
{
    NSData *data=[[NetService singleHttpService] loginByNameAndPasswd:self.username password:self.pwd imei:[UIHelper getOpenUDID]];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        NSLog(@"======%@",nd);
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            NSData *cardata=[[NetService singleHttpService] getCarList:self.username];
            if(cardata)
            {
                NSDictionary *carnd=[cardata objectFromJSONData];
               // NSLog(@"=====%@",carnd);
                if([[carnd objectForKey:@"resp_status"] isEqualToString:@"OK"])
                {
                    [MyDefaults setUserName:self.username];
                    [MyDefaults setPwd:self.pwd];
                    [MyDefaults setToken:[[nd objectForKey:@"resp_data"] objectForKey:@"access_token"]];
                    [self performSelectorOnMainThread:@selector(getResult:) withObject:carnd waitUntilDone:NO];
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(faliResult) withObject:nil waitUntilDone:NO];
                }
            }
            else
            {
                [self performSelectorOnMainThread:@selector(faliResult) withObject:nil waitUntilDone:NO];
            }
        }
        else
        {
            [self performSelectorOnMainThread:@selector(faliResult) withObject:nil waitUntilDone:NO];
        }
    }
    else
    {
        [self performSelectorOnMainThread:@selector(faliResult) withObject:nil waitUntilDone:NO];
    }
}

-(void)getResult:(NSDictionary *)nd
{
    NSLog(@"-----%@",nd);
    [self closeProgressDialog];
    NSDictionary *resp=[nd objectForKey:@"resp_data"];
    if(![[resp objectForKey:@"tu_num"] isEqualToString:@"0"])
    {
        NSString *tuid=[[[resp objectForKey:@"tu_list"] objectForKey:@"0"] objectForKey:@"tu_id"];
        [MyDefaults setTuid:tuid];
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)faliResult
{
    [self closeProgressDialog];
    [UIHelper showAlertview:@"登录失败,请重新再试试！"];

}

-(void)exitView
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)resumeView
{
    [UIView beginAnimations:@"showkeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    self.view.frame=CGRectMake(0.0f,20.0f, width, height);
    [UIView commitAnimations];
}

-(void)hideKeyBoard
{
    [nameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resumeView];
    UITouch *touch=[touches anyObject];
    UIView *view=(UIView *)[touch view];
    if(view==self.view)
    {
        [self hideKeyBoard];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyBoard];
    [self resumeView];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect frame=textField.frame;
    int offset=frame.origin.y+80.0-(self.view.frame.size.height-216.0);
    [UIView beginAnimations:@"showkeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    if(offset>0)
    {
        self.view.frame=CGRectMake(0.0f, -offset, width, height);
    }else
    {
        self.view.frame=CGRectMake(0.0f, 0.0f, width, height);
    }
    [UIView commitAnimations];
    return YES;
}

-(void)dealloc
{
    self.username=nil;
    self.pwd=nil;
    [super dealloc];
}

@end
