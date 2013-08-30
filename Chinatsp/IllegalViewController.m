//
//  IllegalViewController.m
//  ChangAn
//
//  Created by yuante on 13-6-21.
//  Copyright (c) 2013年 yuante. All rights reserved.
//

#define TrafficTag 1001
#define NumTypeTag 1002
#define CarCityTag 1003
#define QueryTag 1004

#import "IllegalViewController.h"
#import "IllegalListViewController.h"
#import "NetService.h"
#import "NSData+Base64.h"
#import "JSONKit.h"
#import "UIHelper.h"
#import "config.h"

@interface IllegalViewController ()

@end

@implementation IllegalViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"违章查询";
        self.hidesBottomBarWhenPushed=YES;
        self.selectcarorg=@"beijing";
        self.selectlstype=@"02";
        self.lsprefixStr=@"京";
        isLoad=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(backBtn)] autorelease];
//	self.view.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
//    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0];
    [self initViews];
    
}

-(void)initViews
{
    UIScrollView *scoll=[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0-44.0-70.5+(iPhone5?88:0))];
                                                                      
    UILabel *trafficlabel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, 20.0, 80.0, 25.0)];
    trafficlabel.text=@"交管局:";
    trafficlabel.textColor=[UIColor whiteColor];
    trafficlabel.backgroundColor=[UIColor clearColor];
    [scoll addSubview:trafficlabel];
    [trafficlabel release];
    
    trafficeer=[[UITextField alloc] initWithFrame:CGRectMake(trafficlabel.frame.origin.x+trafficlabel.frame.size.width, 10.0, 220.0, 40.0)];
    trafficeer.borderStyle=UITextBorderStyleRoundedRect;
    trafficeer.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    trafficeer.delegate=self;
    trafficeer.text=@"北京";
    [scoll addSubview:trafficeer];
    [trafficeer release];
    UIButton *trafficbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    trafficbtn.tag=TrafficTag;
    [trafficbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    trafficbtn.frame=CGRectMake(trafficlabel.frame.origin.x+trafficlabel.frame.size.width, 10.0, 220.0, 40.0);
    [scoll addSubview:trafficbtn];
    
    UILabel *numtypelabel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, trafficlabel.frame.size.height+trafficlabel.frame.origin.y+20.0, 80.0, 25.0)];
    numtypelabel.text=@"号牌类型:";
    numtypelabel.textColor=[UIColor whiteColor];
    numtypelabel.backgroundColor=[UIColor clearColor];
    [scoll addSubview:numtypelabel];
    [numtypelabel release];
    
    numType=[[UITextField alloc] initWithFrame:CGRectMake(numtypelabel.frame.origin.x+numtypelabel.frame.size.width, trafficeer.frame.origin.y+trafficeer.frame.size.height+5.0, 220.0, 40.0)];
    numType.borderStyle=UITextBorderStyleRoundedRect;
    numType.text=@"小型汽车号牌";
    numType.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    numType.delegate=self;
    [scoll addSubview:numType];
    [numType release];
    
    UIButton *numtypebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    numtypebtn.frame=CGRectMake(numtypelabel.frame.origin.x+numtypelabel.frame.size.width, trafficeer.frame.origin.y+trafficeer.frame.size.height+5.0, 220.0, 40.0);
    [numtypebtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    numtypebtn.tag=NumTypeTag;
    [scoll addSubview:numtypebtn];
    
    UILabel *carCitylabel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, numtypelabel.frame.size.height+numtypelabel.frame.origin.y+20.0, 80.0, 25.0)];
    carCitylabel.text=@"车牌:";
    carCitylabel.textColor=[UIColor whiteColor];
    carCitylabel.backgroundColor=[UIColor clearColor];
    [scoll addSubview:carCitylabel];
    [carCitylabel release];
    
    carCity=[[UITextField alloc] initWithFrame:CGRectMake(carCitylabel.frame.origin.x+carCitylabel.frame.size.width, numType.frame.size.height+numType.frame.origin.y+5.0, 70.0, 40.0)];
    carCity.borderStyle=UITextBorderStyleRoundedRect;
    carCity.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    carCity.delegate=self;
    carCity.text=@"京";
    [scoll addSubview:carCity];
    [carCity release];
    UIButton *carcitytag=[UIButton buttonWithType:UIButtonTypeCustom];
    carcitytag.tag=CarCityTag;
    [carcitytag addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    carcitytag.frame=CGRectMake(carCitylabel.frame.origin.x+carCitylabel.frame.size.width, numType.frame.size.height+numType.frame.origin.y+5.0, 70.0, 40.0);
    [scoll addSubview:carcitytag];
    
    carNum=[[UITextField alloc] initWithFrame:CGRectMake(carCity.frame.origin.x+carCity.frame.size.width+5.0, numType.frame.size.height+numType.frame.origin.y+5.0, 145.0, 40.0)];
    carNum.borderStyle=UITextBorderStyleRoundedRect;
    carNum.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    carNum.delegate=self;
    [scoll addSubview:carNum];
    [carNum release];
    
    UILabel *enginelabel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, carCitylabel.frame.size.height+carCitylabel.frame.origin.y+20.0, 80.0, 25.0)];
    enginelabel.text=@"发动机号:";
    enginelabel.textColor=[UIColor whiteColor];
    enginelabel.backgroundColor=[UIColor clearColor];
    [scoll addSubview:enginelabel];
    [enginelabel release];
    
    engineNum=[[UITextField alloc] initWithFrame:CGRectMake(enginelabel.frame.origin.x+enginelabel.frame.size.width, carCity.frame.origin.y+carCity.frame.size.height+5.0, 220.0, 40.0)];
    engineNum.borderStyle=UITextBorderStyleRoundedRect;
    engineNum.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    engineNum.delegate=self;
    engineNum.placeholder=@"选填";
    [scoll addSubview:engineNum];
    [engineNum release];
    
    UILabel *framelabel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, enginelabel.frame.size.height+enginelabel.frame.origin.y+20.0, 80.0, 25.0)];
    framelabel.text=@"车架号:";
    framelabel.textColor=[UIColor whiteColor];
    framelabel.backgroundColor=[UIColor clearColor];
    [scoll addSubview:framelabel];
    [framelabel release];
    
    frameNum=[[UITextField alloc] initWithFrame:CGRectMake(framelabel.frame.origin.x+framelabel.frame.size.width, engineNum.frame.origin.y+engineNum.frame.size.height+5.0, 220.0, 40.0)];
    frameNum.borderStyle=UITextBorderStyleRoundedRect;
    frameNum.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    frameNum.delegate=self;
    frameNum.placeholder=@"选填";
    [scoll addSubview:frameNum];
    [frameNum release];
    
    indentifyImg=[[UIImageView alloc] initWithFrame:CGRectMake(110.0, frameNum.frame.origin.y+frameNum.frame.size.height+5.0, 100.0, 30.0)];
    [scoll addSubview:indentifyImg];
    [indentifyImg release];
    
    UITapGestureRecognizer *singletap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadIndentify)];
    singletap.numberOfTapsRequired=1;
    
    errorindentify=[[UILabel alloc] initWithFrame:CGRectMake(35.0, frameNum.frame.origin.y+frameNum.frame.size.height+5.0, 250.0, 30.0)];
    errorindentify.text=@"获取验证码失败,请点击重新加载";
    errorindentify.backgroundColor=[UIColor clearColor];
    errorindentify.textColor=[UIColor whiteColor];
    errorindentify.userInteractionEnabled=YES;
    [errorindentify addGestureRecognizer:singletap];
    [scoll addSubview:errorindentify];
    [errorindentify release];
    [singletap release];
    
    indentifyCode=[[UITextField alloc] initWithFrame:CGRectMake(10.0, indentifyImg.frame.size.height+indentifyImg.frame.origin.y+5.0, 300.0, 40.0)];
    indentifyCode.delegate=self;
    indentifyCode.placeholder=@"请输入验证码";
    indentifyCode.borderStyle=UITextBorderStyleRoundedRect;
    indentifyCode.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [scoll addSubview:indentifyCode];
    [indentifyCode release];
    
    UIButton *confirmbtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmbtn.frame=CGRectMake(10.0, indentifyCode.frame.size.height+indentifyCode.frame.origin.y+5.0, 300.0, 40.0);
    confirmbtn.tag=QueryTag;
    [confirmbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmbtn setTitle:@"查询" forState:UIControlStateNormal];
    [scoll addSubview:confirmbtn];
    
    [scoll setContentSize:CGSizeMake(320.0, confirmbtn.frame.size.height+confirmbtn.frame.origin.y+10.0)];
    [self.view addSubview:scoll];
    [scoll release];
}

-(void)btnClick:(UIButton *)sender
{
    UIButton *btn=(UIButton *)sender;
    if(btn.tag==TrafficTag)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarDisappear" object:nil];
        illegalCategoryViewController *category=[[illegalCategoryViewController alloc] init];
        category.flag=0;
        category.delegate=self;
        [self.navigationController pushViewController:category animated:YES];
        [category release];
    }
    else if (btn.tag==NumTypeTag)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarDisappear" object:nil];
        illegalCategoryViewController *category=[[illegalCategoryViewController alloc] init];
        category.flag=1;
        category.delegate=self;
        [self.navigationController pushViewController:category animated:YES];
        [category release];
    }
    else if (btn.tag==CarCityTag)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarDisappear" object:nil];
        illegalCategoryViewController *category=[[illegalCategoryViewController alloc] init];
        category.flag=2;
        category.delegate=self;
        [self.navigationController pushViewController:category animated:YES];
        [category release];
    }
    else if (btn.tag==QueryTag)
    {
        self.carNumStr=carNum.text;
        self.engineNumStr=engineNum.text;
        self.frameStr=frameNum.text;
        self.indentifyStr=indentifyCode.text;
        self.lsprefixStr=carCity.text;
        NSLog(@"----%@",self.selectcarorg);
        if([UIHelper stringIsEmptyOrIsNull:self.carNumStr])
        {
            [UIHelper showAlertview:@"请输入车牌号"];
            return;
        }
//        if([UIHelper stringIsEmptyOrIsNull:self.engineNumStr])
//        {
//            [UIHelper showAlertview:@"请输入发动机号"];
//            return;
//        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarDisappear" object:nil];
        IllegalListViewController *illeagallist=[[IllegalListViewController alloc] init];
        illeagallist.carorg=self.selectcarorg;
        illeagallist.lstype=self.selectlstype;
        illeagallist.lsprefixStr=self.lsprefixStr;
        illeagallist.carNumStr=self.carNumStr;
        illeagallist.engineNumStr=self.engineNumStr;
        illeagallist.frameStr=self.frameStr;
        illeagallist.indentifyStr=self.indentifyStr;
        illeagallist.cookie=self.cookie;
        [self.navigationController pushViewController:illeagallist animated:YES];
        [illeagallist release];
    }
}

-(void)backBtn
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadIndentify];
}

-(void)loadIndentify
{
    if(!isLoad)
    {
        isLoad=YES;
        [self createProgressDialog];
        [indentifyImg setHidden:YES];
        [errorindentify setHidden:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data=[[NetService singleHttpService] getInditify:self.selectcarorg];
            if(data)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    isLoad=NO;
                    [self closeProgressDialog];
                    NSDictionary *nd=[data objectFromJSONData];
                    if(!nd)
                    {
                        [indentifyCode setHidden:YES];
                    }
                    else
                    {
                        self.cookie=[nd objectForKey:@"cookie"];
                        NSString *str=[nd objectForKey:@"img"];
                        NSData *data1=[NSData dataFromBase64String:str];
                        UIImage *img=[UIImage imageWithData:data1];
                        [indentifyImg setHidden:NO];
                        indentifyImg.image=img;
                        [indentifyCode setHidden:NO];
                    }
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    isLoad=NO;
                    [self closeProgressDialog];
                    [errorindentify setHidden:NO];
                });
            }
        });
    }
}

-(void)createProgressDialog
{
    progressdialog = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    progressdialog.frame = CGRectMake(110.0, frameNum.frame.origin.y+frameNum.frame.size.height+5.0, 30.0, 30.0);
    [self.view addSubview:progressdialog];
    [progressdialog release];
    
    [progressdialog startAnimating];
}

-(void)closeProgressDialog
{
    if (progressdialog) {
        [progressdialog stopAnimating];
        [progressdialog removeFromSuperview];
        progressdialog = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);      //还原上一步view上提效果
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y+60.0- (self.view.frame.size.height - 216.0);//求出键盘顶部与textfield底部大小的距离
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height); //上推键盘操作,view大小始终没变
        self.view.frame = rect;
    }       
    [UIView commitAnimations];
}

-(void)getCarorg:(NSString *)name value:(NSString *)value
{
    self.selectcarorg=value;
    trafficeer.text=name;
    
}

-(void)getLstype:(NSString *)name value:(NSString *)value
{
    self.selectlstype=value;
    numType.text=name;
}

-(void)getLsprefix:(NSString *)name
{
    carCity.text=name;
}

-(void)dealloc
{
    self.selectlstype=nil;
    self.selectcarorg=nil;
    self.lsprefixStr=nil;
    self.carNumStr=nil;
    self.engineNumStr=nil;
    self.frameStr=nil;
    self.indentifyStr=nil;
    self.cookie=nil;
    [super dealloc];
}
@end
