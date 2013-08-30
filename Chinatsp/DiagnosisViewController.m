//
//  DiagnosisViewController.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-26.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#define DiagnosisTag  101
#define OrderTag  102
#define sendCommantTag 103

#import "DiagnosisViewController.h"
#import "UIHelper.h"
#import "NetService.h"
#import "JSONKit.h"
#import "CarFault.h"
#import "CarStoreListViewController.h"
#import "config.h"
#import "LoadingMoreFooterView.h"

@interface DiagnosisViewController ()

@end

@implementation DiagnosisViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
        dataArray=[[NSMutableArray alloc] init];
        pageNum=0;
        selectFlag=-1;
        self.title=@"远程诊断";
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
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"发起诊断" style:UIBarButtonItemStyleBordered target:self action:@selector(sendDiagnosisClick)] autorelease];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initButtons];
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(getDiagnosisListInThread) toTarget:self withObject:nil];
	// Do any additional setup after loading the view.
}

-(void)initButtons
{
    UIView *diagnosibg=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 345.5+(iPhone5?88:0))];
    diagnosibg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    [self.view addSubview:diagnosibg];
    [diagnosibg release];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake((320-304.5)/2, 0.0, 304.5+(iPhone5?88:0), 460.0-44.0-70.5+(iPhone5?88:0)) style:UITableViewStylePlain];
    table.backgroundColor=[UIColor clearColor];
    table.delegate=self;
    table.dataSource=self;
    table.separatorStyle=NO;
    [diagnosibg addSubview:table];
    [table release];
    
    self.loadFooterView=[[[LoadingMoreFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 20.0f)] autorelease];
    self.loadFooterView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.05];
    table.tableFooterView=self.loadFooterView;
    [table.tableFooterView setHidden:YES];
    
    _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - table.bounds.size.height, self.view.frame.size.width, table.bounds.size.height) identify:@"diagnoisLastTime"];
    _refreshHeaderView.delegate=self;
    [table addSubview:_refreshHeaderView];
    [_refreshHeaderView release];
    
    [_refreshHeaderView getLastUpdatedDate:@"diagnoisLastTime"];
    
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

-(void)sendDiagnosisClick
{
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(getDiagnosisInThread) toTarget:self withObject:nil];
}

-(void)getDiagnosisInThread
{
    NSData *data=[[NetService singleHttpService] sendCommantBywake:WAKE];
    if (data) {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            data=[[NetService singleHttpService] sendCommantBystatus:@"DIAGNOSIS-ALL"];
            [self performSelectorOnMainThread:@selector(getCommandResult:) withObject:data waitUntilDone:NO];
        }
    }else
    {
        [self performSelectorOnMainThread:@selector(getCommandResult:) withObject:data waitUntilDone:NO];
    }
}

-(void)getDiagnosisListInThread
{
    NSData *data=[[NetService singleHttpService] sendDiagnosis:pageNum*15];
    [self performSelectorOnMainThread:@selector(getResultDiagnosisList:) withObject:data waitUntilDone:NO];
}

-(void)getCommandResult:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([[nd objectForKey:@"resp_status"] isEqualToString:@"OK"])
        {
            [UIHelper showAlertview:@"诊断成功"];
        }
        else
        {
            [UIHelper showAlertview:@"诊断失败"];
        }
    }
    else
    {
        [UIHelper showAlertview:@"网络异常,诊断失败!"];
    }
}

-(void)getResultDiagnosisList:(NSData *)data
{
    [self closeProgressDialog];
    isLoad=NO;
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        NSLog(@"========%@",nd);
        if([@"OK" isEqualToString:[nd objectForKey:@"resp_status"]])
        {
            if([@"" isEqualToString:[[nd objectForKey:@"resp_data"] objectForKey:@"report_list"]])
            {
                if(pageNum==0)
                {
                    [UIHelper showAlertview:@"没有找到相关数据"];
                }else
                {
                    isLastPage=YES;
//                    self.loadFooterView.currentPageInLoadingMore=0;
//                    self.loadFooterView.showActivityIndicator=NO;
                    [table.tableFooterView setHidden:YES];
                }
            }else
            {
                self.loadFooterView.showActivityIndicator=NO;
                NSArray *tempArray=[[[nd objectForKey:@"resp_data"] objectForKey:@"report_list"] allValues];
                [dataArray addObjectsFromArray:tempArray];
                if([dataArray count]<15)
                {
                    isLastPage=YES;
                    [table.tableFooterView setHidden:YES];
                }
                else
                {
                    [table.tableFooterView setHidden:NO];
                }
                [table reloadData];
            }
        }else
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
        [self showNetAlertView];
        [self performSelector:@selector(hideNetAlertView) withObject:nil afterDelay:3.0];
    }
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

-(void)cellBtn:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if(selectFlag==btn.tag)
    {
        selectFlag=-1;
        NSIndexPath *path=[NSIndexPath indexPathForRow:btn.tag inSection:0];
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
        [table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else
    {
        int tempflag=selectFlag;
        selectFlag=-1;
        NSIndexPath *path=[NSIndexPath indexPathForRow:tempflag inSection:0];
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
        NSIndexPath *path1=[NSIndexPath indexPathForRow:btn.tag inSection:0];
        selectFlag=btn.tag;
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:path1] withRowAnimation:UITableViewRowAnimationFade];
        [table scrollToRowAtIndexPath:path1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)repairBtn:(id)sender
{
    CarStoreListViewController *carstore=[[CarStoreListViewController alloc] init];
    carstore.notShowHome=YES;
    [self.navigationController pushViewController:carstore animated:YES];
    [carstore release];
}

-(void)refreshTableListInThread
{
    NSData *data=[[NetService singleHttpService] sendDiagnosis:0];
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData:) withObject:data waitUntilDone:NO];
}

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [NSThread detachNewThreadSelector:@selector(refreshTableListInThread) toTarget:self withObject:nil];
}

- (void)doneLoadingTableViewData:(NSData *)data{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:table];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([@"OK" isEqualToString:[nd objectForKey:@"resp_status"]])
        {
            [table.tableFooterView setHidden:YES];
            isLastPage=NO;
            self.loadFooterView.currentPageInLoadingMore=-1;
            self.loadFooterView.showActivityIndicator=NO;
            pageNum=0;
            [dataArray removeAllObjects];
            if([@"" isEqualToString:[[nd objectForKey:@"resp_data"] objectForKey:@"report_list"]])
            {
                [UIHelper showAlertview:@"没有找到相关数据"];
            }else
            {
                NSArray *tempArray=[[[nd objectForKey:@"resp_data"] objectForKey:@"report_list"] allValues];
                [dataArray addObjectsFromArray:tempArray];
                if([dataArray count]<15)
                {
                    isLastPage=YES;
                    [table.tableFooterView setHidden:YES];
                }
                else
                {
                    [table.tableFooterView setHidden:NO];
                }
            }
            [table reloadData];
        }
        else
        {
            [UIHelper showAlertview:@"获取数据失败"];
        }
    }
    else
    {
        [self showNetAlertView];
        [self performSelector:@selector(hideNetAlertView) withObject:nil afterDelay:3.0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *nd=[dataArray objectAtIndex:[indexPath row]];
    UILabel *time=[[[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 100, 25.0)] autorelease];
    time.textColor=[UIColor whiteColor];
    time.backgroundColor=[UIColor clearColor];
    time.text=[nd objectForKey:@"time"];
    [time sizeToFit];
    [cell.contentView addSubview:time];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0.0, 0.0, 304.5, 45.0);
    [btn setImage:[UIImage imageNamed:@"head_bg"] forState:UIControlStateNormal];
    btn.tag=[indexPath row];
    [btn addTarget:self action:@selector(cellBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn];
    
    UILabel *abs_statuslabel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, btn.frame.size.height+btn.frame.origin.y+5.0, 304.5, 25.0)] autorelease];
    abs_statuslabel.numberOfLines=0;
    abs_statuslabel.textColor=[UIColor whiteColor];
    abs_statuslabel.backgroundColor=[UIColor clearColor];
    abs_statuslabel.text=[nd objectForKey:@"abs_status"];
    [abs_statuslabel sizeToFit];
    [cell.contentView addSubview:abs_statuslabel];
    
    UILabel *engine_statuslabel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, abs_statuslabel.frame.size.height+abs_statuslabel.frame.origin.y, 304.5, 25.0)] autorelease];
    engine_statuslabel.numberOfLines=0;
    engine_statuslabel.textColor=[UIColor whiteColor];
    engine_statuslabel.backgroundColor=[UIColor clearColor];
    engine_statuslabel.text=[nd objectForKey:@"engine_status"];
    [engine_statuslabel sizeToFit];
    [cell.contentView addSubview:engine_statuslabel];
    
    UILabel *eps_statuslabel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, engine_statuslabel.frame.size.height+engine_statuslabel.frame.origin.y, 304.5, 25.0)] autorelease];
    eps_statuslabel.numberOfLines=0;
    eps_statuslabel.textColor=[UIColor whiteColor];
    eps_statuslabel.backgroundColor=[UIColor clearColor];
    eps_statuslabel.text=[nd objectForKey:@"eps_status"];
    [eps_statuslabel sizeToFit];
    [cell.contentView addSubview:eps_statuslabel];
    
    UILabel *system_statuslabel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, eps_statuslabel.frame.size.height+eps_statuslabel.frame.origin.y, 304.5, 25.0)] autorelease];
    system_statuslabel.numberOfLines=0;
    system_statuslabel.textColor=[UIColor whiteColor];
    system_statuslabel.backgroundColor=[UIColor clearColor];
    system_statuslabel.text=[nd objectForKey:@"system_status"];
    [system_statuslabel sizeToFit];
    [cell.contentView addSubview:system_statuslabel];
    
    UILabel *tcs_esp_statuslabel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, system_statuslabel.frame.size.height+system_statuslabel.frame.origin.y, 304.5, 25.0)] autorelease];
    tcs_esp_statuslabel.numberOfLines=0;
    tcs_esp_statuslabel.textColor=[UIColor whiteColor];
    tcs_esp_statuslabel.backgroundColor=[UIColor clearColor];
    tcs_esp_statuslabel.text=[nd objectForKey:@"tcs/esp_status"];
    [tcs_esp_statuslabel sizeToFit];
    [cell.contentView addSubview:tcs_esp_statuslabel];
    
    UILabel *tpms_statuslabel=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, tcs_esp_statuslabel.frame.size.height+tcs_esp_statuslabel.frame.origin.y, 304.5, 25.0)] autorelease];
    tpms_statuslabel.numberOfLines=0;
    tpms_statuslabel.textColor=[UIColor whiteColor];
    tpms_statuslabel.backgroundColor=[UIColor clearColor];
    tpms_statuslabel.text=[nd objectForKey:@"tpms_status"];
    [tpms_statuslabel sizeToFit];
    [cell.contentView addSubview:tpms_statuslabel];
    
    UIButton *mainbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    mainbtn.frame=CGRectMake(160.0, tpms_statuslabel.frame.size.height+tpms_statuslabel.frame.origin.y+5.0, 118.5, 41.0);
    [mainbtn addTarget:self action:@selector(repairBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainbtn setImage:[UIImage imageNamed:@"maintain_btn"] forState:UIControlStateNormal];
    [cell.contentView addSubview:mainbtn];
    
    if(selectFlag==[indexPath row])
    {
        [abs_statuslabel setHidden:NO];
        [engine_statuslabel setHidden:NO];
        [eps_statuslabel setHidden:NO];
        [system_statuslabel setHidden:NO];
        [tcs_esp_statuslabel setHidden:NO];
        [tpms_statuslabel setHidden:NO];
        [mainbtn setHidden:NO];
        [btn setImage:[UIImage imageNamed:@"diagnois_header"] forState:UIControlStateNormal];
        //设置高度
        CGFloat height=mainbtn.frame.origin.y+mainbtn.frame.size.height+3.0f;
        CGRect rect=CGRectMake(0.0f, 0.0f, cell.bounds.size.width, height);
        cell.bounds=rect;
    }
    else{
        [abs_statuslabel setHidden:YES];
        [engine_statuslabel setHidden:YES];
        [eps_statuslabel setHidden:YES];
        [system_statuslabel setHidden:YES];
        [tcs_esp_statuslabel setHidden:YES];
        [tpms_statuslabel setHidden:YES];
        [mainbtn setHidden:YES];
        [btn setImage:[UIImage imageNamed:@"head_bg"] forState:UIControlStateNormal];
        cell.bounds=CGRectMake(0.0f, 0.0f, cell.bounds.size.width, 50.0);
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    if (scrollView.dragging ==YES)
    {
        if (scrollView.frame.size.height - (scrollView.contentSize.height - scrollView.contentOffset.y) > 40&&scrollView.contentOffset.y>0) {
            self.loadFooterView.textLabel.text = @"松开即可加载……";
        }
        else
        {
            self.loadFooterView.textLabel.text = @"上拉可以加载更多……";
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if (scrollView.frame.size.height - (scrollView.contentSize.height - scrollView.contentOffset.y) > 40&&scrollView.contentOffset.y>0&&!isLoad&&!isLastPage)
    {
            self.loadFooterView.showActivityIndicator=YES;
            isLoad=YES;
            pageNum++;
            NSThread *thread=[[[NSThread alloc] initWithTarget:self selector:@selector(getDiagnosisListInThread) object:nil] autorelease];
            [thread start];

    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
	[self reloadTableViewDataSource];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

-(void)dealloc
{
    [dataArray release];
    dataArray=nil;
    self.loadFooterView=nil;
    [super dealloc];
}

@end
