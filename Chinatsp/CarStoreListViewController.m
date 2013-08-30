//
//  CarStoreListViewController.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-27.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "CarStoreListViewController.h"
#import "NetService.h"
#import "UIHelper.h"
#import "JSONKit.h"
#import "LoadingMoreFooterView.h"
#import "Collect.h"

@interface CarStoreListViewController ()

@end

@implementation CarStoreListViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"保养维修";
        self.hidesBottomBarWhenPushed=YES;
        array=[[NSMutableArray alloc] init];
        pageNum=0;
        isLastPage=NO;
        isLoad=NO;
        isShownet=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    UIView *illbg=[[UIView alloc] initWithFrame:CGRectMake(0.0,0.0, 320.0, 460.0-44.0+(iPhone5?88:0))];
    if(iPhone5)
    {
        illbg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg-568h"]];
    }else
    {
        illbg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    }
    [self.view addSubview:illbg];
    [illbg release];
    if(!self.notShowHome)
    {
        self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    }
    self.view.backgroundColor=[UIColor blackColor];
    [self initViews];
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(getFourSListInThread) toTarget:self withObject:nil];
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    UIView *baoyangbg=[[UIView alloc] initWithFrame:CGRectMake(0.0,0.0, 320.0, 460.0-44.0+(iPhone5?88:0))];
    if(iPhone5)
    {
        baoyangbg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg-568h"]];
    }else
    {
        baoyangbg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    }
    [self.view addSubview:baoyangbg];
    [baoyangbg release];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake((320.0-304.5)/2, 0.0, 304.5, 460.0-44.0-70.5+(iPhone5?88:0)) style:UITableViewStylePlain];
    table.backgroundColor=[UIColor clearColor];
    table.separatorStyle=NO;
    table.dataSource=self;
    table.delegate=self;
    [baoyangbg addSubview:table];
    [table release];
    
    self.loadFooterView=[[[LoadingMoreFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 20.0f)] autorelease];
    self.loadFooterView.backgroundColor=[UIColor clearColor];
    table.tableFooterView=self.loadFooterView;
    [table.tableFooterView setHidden:YES];
    
    netalertview=[[UIView alloc] initWithFrame:CGRectMake((320.0-150.0)/2,((iPhone5?88:0)+460.0)/2-44.0-70.5, 150.0, 80.0)];
    netalertview.backgroundColor = [UIColor blackColor];
    netalertview.alpha=0.0;
    [self.view addSubview:netalertview];
    [netalertview release];
    
    UILabel *nettxt=[[UILabel alloc] initWithFrame:CGRectMake(30.0, (80.0-25.0)/2, 90.0, 25.0)];
    nettxt.textColor=[UIColor whiteColor];
    nettxt.backgroundColor=[UIColor clearColor];
    nettxt.text=@"网络不给力";
    [netalertview addSubview:nettxt];
    [nettxt release];
}

-(void)btnClick
{
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)getFourSListInThread
{
    NSData *data=[[NetService singleHttpService] getFourSList:pageNum*15];
    [self performSelectorOnMainThread:@selector(getResult:) withObject:data waitUntilDone:NO];
}

-(void)getResult:(NSData *)data
{
    [self closeProgressDialog];
    isLoad=NO;
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        //NSLog(@"------%@",nd);
        if([@"OK" isEqualToString:[nd objectForKey:@"resp_status"]])
        {
            
            if([@"" isEqualToString:[nd objectForKey:@"resp_data"]])
            {
                if(pageNum==0)
                {
                    [UIHelper showAlertview:@"没有找到相关数据"];
                }else
                {
                    isLastPage=YES;
                    self.loadFooterView.currentPageInLoadingMore=0;
                    self.loadFooterView.showActivityIndicator=NO;
                }
            }
            else
            {
                self.loadFooterView.showActivityIndicator=NO;
                NSArray *tempArray=[[nd objectForKey:@"resp_data"] allValues];
                [array addObjectsFromArray:tempArray];
                if([array count]!=0)
                {
                    [table.tableFooterView setHidden:NO];
                }
                [table reloadData];
            }
        }
        else
        {
            if(pageNum!=0)
            {
                pageNum--;
            }
            self.loadFooterView.showActivityIndicator=NO;
            [UIHelper showAlertview:@"获取数据失败"];
        }
    }
    else
    {
        if(pageNum!=0)
        {
            pageNum--;
        }
        self.loadFooterView.showActivityIndicator=NO;
        [UIHelper showAlertview:@"网络异常"];
    }
}

-(void)CloudClick:(id)sender
{
    [self createProgressDialog];
    UIButton *btn=(UIButton *)sender;
    NSDictionary *info=[array objectAtIndex:btn.tag];
    Collect *collect=[[Collect alloc] init];
    collect.title=[info objectForKey:@"address"];
    collect.lat=[[info objectForKey:@"lat"] doubleValue];
    collect.lon=[[info objectForKey:@"lng"] doubleValue];
    [NSThread detachNewThreadSelector:@selector(iCloudyDataInsert:) toTarget:self withObject:collect];
    [collect release];
}

-(void)iCloudyDataInsert:(Collect *)collect
{
    NSData *data=[[NetService singleHttpService] insertClouy:collect];
    [self performSelectorOnMainThread:@selector(getInsertCloudyResult:) withObject:data waitUntilDone:NO];
}

-(void)showNetAlertView
{
    isShownet=YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    netalertview.alpha=1.0;
    [UIView commitAnimations];
}

-(void)hideNetAlertView
{
    isShownet=NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    netalertview.alpha=0.0;
    [UIView commitAnimations];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
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
    NSDictionary *nd=[array objectAtIndex:[indexPath row]];
    UIImageView *cellbg=[[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 304.5, 116.5)] autorelease];
    cellbg.userInteractionEnabled=YES;
    cellbg.image=[UIImage imageNamed:@"poi_bg"];
    [cell.contentView addSubview:cellbg];
    UILabel *title=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 300.0, 25.0)] autorelease];
    title.numberOfLines=1;
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    title.text=[nd objectForKey:@"name"];
    [cellbg addSubview:title];
    
    UILabel *addr=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, title.frame.size.height+title.frame.origin.y, 300.0, 20.0)] autorelease];
    addr.numberOfLines=1;
    addr.textColor=[UIColor whiteColor];
    addr.backgroundColor=[UIColor clearColor];
    addr.text=[nd objectForKey:@"address"];
    addr.font=[UIFont systemFontOfSize:14.0];
    [cellbg addSubview:addr];
    
    UILabel *tel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, addr.frame.size.height+addr.frame.origin.y, 300.0, 20.0)] autorelease];
    tel.numberOfLines=1;
    tel.textColor=[UIColor whiteColor];
    tel.backgroundColor=[UIColor clearColor];
    tel.text=[nd objectForKey:@"telephone"];
    tel.font=[UIFont systemFontOfSize:14.0];
    [cell.contentView addSubview:tel];
    
//    UIButton *telbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    telbtn.frame=CGRectMake(20.0, tel.frame.size.height+tel.frame.origin.y+5.0, 80.0, 28.5);
//    telbtn.tag=[indexPath row];
//    [telbtn addTarget:self action:@selector(TelClick:) forControlEvents:UIControlEventTouchUpInside];
//    [telbtn setImage:[UIImage imageNamed:@"poi_tel"] forState:UIControlStateNormal];
//    [cellbg addSubview:telbtn];
//    
//    UIButton *mapbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    mapbtn.frame=CGRectMake(telbtn.frame.size.width+telbtn.frame.origin.x+10.0, tel.frame.size.height+tel.frame.origin.y+5.0, 80.0, 28.5);
//    [mapbtn addTarget:self action:@selector(MapClick:) forControlEvents:UIControlEventTouchUpInside];
//    mapbtn.tag=[indexPath row];
//    [mapbtn setImage:[UIImage imageNamed:@"poi_map"] forState:UIControlStateNormal];
//    [cellbg addSubview:mapbtn];
    
//    UIButton *collectbtn=[[[UIButton alloc] initWithFrame:CGRectMake(mapbtn.frame.size.width+mapbtn.frame.origin.x+10.0, tel.frame.size.height+tel.frame.origin.y+5.0, 80.0, 28.5)] autorelease];
    UIButton *collectbtn=[[[UIButton alloc] initWithFrame:CGRectMake(200.0, tel.frame.size.height+tel.frame.origin.y+5.0, 80.0, 28.5)] autorelease];
    collectbtn.tag=[indexPath row];
    [collectbtn addTarget:self action:@selector(CloudClick:) forControlEvents:UIControlEventTouchUpInside];
    [collectbtn setImage:[UIImage imageNamed:@"poi_collect"] forState:UIControlStateNormal];
    [cellbg addSubview:collectbtn];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if([array count]==0)
    {
        return;
    }
    //NSLog(@"当前的页数=====%d",pageNum);
    if(bottomEdge>=floor(scrollView.contentSize.height)&&!isLoad&&!isLastPage)
    {
        if(![UIHelper checkNetIsConnect])
        {
            if(!isShownet)
            {
                [self showNetAlertView];
                [self performSelector:@selector(hideNetAlertView) withObject:nil afterDelay:3.0];
            }
            return;
        }
        self.loadFooterView.showActivityIndicator=YES;
        isLoad=YES;
        pageNum++;
        NSThread *thread=[[[NSThread alloc] initWithTarget:self selector:@selector(getFourSListInThread) object:nil] autorelease];
        [thread start];
    }
}

-(void)dealloc
{
    [array release];
    array=nil;
    self.loadFooterView=nil;
    [super dealloc];
}

@end
