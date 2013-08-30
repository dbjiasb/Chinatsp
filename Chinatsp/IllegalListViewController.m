//
//  IllegalListViewController.m
//  ChangAn
//
//  Created by yuante on 13-7-3.
//  Copyright (c) 2013年 yuante. All rights reserved.
//

#import "IllegalListViewController.h"
#import "config.h"
#import "JSONKit.h"
#import "NetService.h"
#import "UIHelper.h"

@interface IllegalListViewController ()

@end

@implementation IllegalListViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"违章列表";
        totalArray=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *illcategorybg=[[UIView alloc] initWithFrame:CGRectMake(0.0,0.0, 320.0, 460.0-44.0+(iPhone5?88:0))];
    if(iPhone5)
    {
        illcategorybg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg-568h"]];
    }else
    {
        illcategorybg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    }
	table=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0-70.5+(iPhone5?88:0)) style:UITableViewStylePlain];
    table.backgroundColor=[UIColor clearColor];
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
    [table release];
    [self loadDataFromService];
}

-(void)loadDataFromService
{
    [self createProgressDialog];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data=[[NetService singleHttpService] getIllegalList:self.carorg lstype:self.lstype lsprefix:self.lsprefixStr lsnum:self.carNumStr engineno:self.engineNumStr frameno:self.frameStr imgcode:self.indentifyStr cookie:self.cookie];
        if(data)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self closeProgressDialog];
                NSDictionary *nd=[data objectFromJSONData];
                NSLog(@"----%@",nd);
                if([@"0" isEqualToString:[nd objectForKey:@"error"]])
                {
                    NSArray *temarray=[nd objectForKey:@"data"];
                    [totalArray addObjectsFromArray:temarray];
                    if([totalArray count]==0)
                    {
                        [UIHelper showAlertview:@"没有找到违章数据"];
                    }
                    else
                    {
                        [table reloadData];
                    }
                }
                else
                {
                    [UIHelper showAlertview:[nd objectForKey:@"msg"]];
                }
            });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self closeProgressDialog];
                [UIHelper showAlertview:@"网络异常"];
            });
        }
    });
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0-44.0-70.5+(iPhone5?88:0))];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarAppear" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [totalArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentify];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify] autorelease];
        cell.selectionStyle=NO;
    }
    for (UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    NSDictionary *nd=[totalArray objectAtIndex:[indexPath row]];
    UILabel *timelabel=[[UILabel alloc] initWithFrame:CGRectMake(3.0, 3.0, 250.0, 25.0)];
    timelabel.numberOfLines=1;
    timelabel.backgroundColor=[UIColor clearColor];
    timelabel.text=[NSString stringWithFormat:@"时间:%@",[nd objectForKey:@"time"]];
    timelabel.textColor=[UIColor whiteColor];
    [cell.contentView addSubview:timelabel];
    [timelabel release];
    
    UILabel *addrlabel=[[UILabel alloc] initWithFrame:CGRectMake(3.0, timelabel.frame.size.height+timelabel.frame.origin.y, 310.0, 25.0)];
    addrlabel.numberOfLines=1;
    addrlabel.font=[UIFont systemFontOfSize:14.0];
    addrlabel.backgroundColor=[UIColor clearColor];
    addrlabel.text=[NSString stringWithFormat:@"地址:%@",[nd objectForKey:@"address"]];
    addrlabel.textColor=[UIColor whiteColor];
    [cell.contentView addSubview:addrlabel];
    [addrlabel release];
    
    UILabel *contentlabel=[[UILabel alloc] initWithFrame:CGRectMake(3.0, addrlabel.frame.size.height+addrlabel.frame.origin.y, 310.0, 25.0)];
    contentlabel.numberOfLines=0;
    contentlabel.font=[UIFont systemFontOfSize:14.0];
    contentlabel.backgroundColor=[UIColor clearColor];
    contentlabel.textColor=[UIColor whiteColor];
    contentlabel.text=[NSString stringWithFormat:@"内容:%@",[nd objectForKey:@"content"]];
    [contentlabel sizeToFit];
    [cell.contentView addSubview:contentlabel];
    [contentlabel release];
    
    UILabel *idlabel=[[UILabel alloc] initWithFrame:CGRectMake(3.0, contentlabel.frame.size.height+contentlabel.frame.origin.y, 310.0, 25.0)];
    idlabel.numberOfLines=1;
    idlabel.font=[UIFont systemFontOfSize:14.0];
    idlabel.backgroundColor=[UIColor clearColor];
    idlabel.textColor=[UIColor whiteColor];
    idlabel.text=[NSString stringWithFormat:@"代号:%@",[nd objectForKey:@"legalnum"]];
    [cell.contentView addSubview:idlabel];
    [idlabel release];
    
    UILabel *pricelabel=[[UILabel alloc] initWithFrame:CGRectMake(3.0, idlabel.frame.size.height+idlabel.frame.origin.y, 310.0, 25.0)];
    pricelabel.numberOfLines=1;
    pricelabel.font=[UIFont systemFontOfSize:14.0];
    pricelabel.backgroundColor=[UIColor clearColor];
    pricelabel.textColor=[UIColor whiteColor];
    pricelabel.text=[NSString stringWithFormat:@"罚款金额:%@",[nd objectForKey:@"price"]];
    [cell.contentView addSubview:pricelabel];
    [pricelabel release];
    
    UILabel *scorelabel=[[UILabel alloc] initWithFrame:CGRectMake(3.0, pricelabel.frame.size.height+pricelabel.frame.origin.y, 310.0, 25.0)];
    scorelabel.numberOfLines=1;
    scorelabel.font=[UIFont systemFontOfSize:14.0];
    scorelabel.backgroundColor=[UIColor clearColor];
    scorelabel.textColor=[UIColor whiteColor];
    scorelabel.text=[NSString stringWithFormat:@"扣除分数:%@",[nd objectForKey:@"score"]];
    [cell.contentView addSubview:scorelabel];
    [scorelabel release];
    
    CGFloat height=scorelabel.frame.origin.y+scorelabel.frame.size.height+2.0f;
    CGRect rect=CGRectMake(0.0f, 0.0f, cell.bounds.size.width, height);
    cell.bounds=rect;
    return cell;
}

-(void)dealloc
{
    self.lstype=nil;
    self.carorg=nil;
    self.lsprefixStr=nil;
    self.carNumStr=nil;
    self.engineNumStr=nil;
    self.frameStr=nil;
    self.indentifyStr=nil;
    self.cookie=nil;
    [totalArray release];
    [super dealloc];
}
@end
