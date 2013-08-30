//
//  CloudViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-15.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "CloudViewController.h"
#import "JSONKit.h"
#import "NetService.h"
#import "UIHelper.h"
#import "config.h"

@interface CloudViewController ()
{
    int count;
}
@end

@implementation CloudViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        totalArray=[[NSMutableArray alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        self.title=@"云收藏";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    [self initViews];
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(getDataInThread) toTarget:self withObject:nil];
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    table=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0-44.0-70.5+(iPhone5?88:0)) style:UITableViewStylePlain];
    table.dataSource=self;
    table.delegate=self;
    table.separatorStyle=NO;
    table.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.05];
    [self.view addSubview:table];
    [table release];
    
    _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - table.bounds.size.height, self.view.frame.size.width, table.bounds.size.height) identify:@"cloudLastTime"];
    _refreshHeaderView.delegate=self;
    [table addSubview:_refreshHeaderView];
    [_refreshHeaderView release];
    
    [_refreshHeaderView getLastUpdatedDate:@"cloudLastTime"];
}

-(void)getDataInThread
{
    NSData *data=[[NetService singleHttpService] getCollectList];
    [self performSelectorOnMainThread:@selector(getResult:) withObject:data waitUntilDone:NO];
}

-(void)getResult:(NSData *)data
{
    [self closeProgressDialog];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([@"OK" isEqualToString:[nd objectForKey:@"resp_status"]])
        {
            if([@"" isEqualToString:[nd objectForKey:@"resp_data"]])
            {
                [UIHelper showAlertview:@"目前没有收藏纪录哦"];
            }
            else
            {
                NSDictionary *respNd=[nd objectForKey:@"resp_data"];
                NSArray *valuearray=respNd.allValues;
                [totalArray setArray:valuearray];
                [table reloadData];
            }
        }
        else
        {
            [UIHelper showAlertview:@"获取数据失败,请稍后在试"];
        }
    }
    else
    {
        [UIHelper showAlertview:@"网络异常"];
    }
}

-(void)btnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)deleteDataInThread:(NSNumber *)num
{
    NSData *data=[[NetService singleHttpService] deleteCollect:[[totalArray objectAtIndex:[num intValue]] objectForKey:@"poi_id"]];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([@"OK" isEqualToString:[nd objectForKey:@"resp_status"]])
        {
            [self performSelectorOnMainThread:@selector(deleteDataResult:) withObject:num waitUntilDone:NO];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(deleteFailedResult:) withObject:@"删除失败,请稍候在试" waitUntilDone:NO];
        }
    }
    else
    {
        [self performSelectorOnMainThread:@selector(deleteFailedResult:) withObject:@"网络异常,删除失败" waitUntilDone:NO];
    }
}

-(void)deleteDataResult:(NSNumber *)num
{
    [self closeProgressDialog];
    [totalArray removeObjectAtIndex:[num intValue]];
    [table reloadData];
}

-(void)deleteFailedResult:(NSString *)str
{
    [self closeProgressDialog];
    [UIHelper showAlertview:str];
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

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [NSThread detachNewThreadSelector:@selector(refreshTableListInThread) toTarget:self withObject:nil];
}

-(void)refreshTableListInThread
{
     NSData *data=[[NetService singleHttpService] getCollectList];
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData:) withObject:data waitUntilDone:NO];
}

- (void)doneLoadingTableViewData:(NSData *)data
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:table];
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([@"OK" isEqualToString:[nd objectForKey:@"resp_status"]])
        {
            if([@"" isEqualToString:[nd objectForKey:@"resp_data"]])
            {
                [UIHelper showAlertview:@"没有找到相关数据"];
            }else
            {
                [totalArray removeAllObjects];
                NSDictionary *respNd=[nd objectForKey:@"resp_data"];
                NSArray *valuearray=respNd.allValues;
                [totalArray setArray:valuearray];
                [table reloadData];
            }
        }
        else
        {
            [UIHelper showAlertview:@"获取数据失败,请稍后在试"];
        }
    }
    else
    {
        [UIHelper showAlertview:@"网络异常"];
    }
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
    
    UILabel *content=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 300.0, 25.0)] autorelease];
    content.numberOfLines=0;
    content.textColor=[UIColor whiteColor];
    content.backgroundColor=[UIColor clearColor];
//    NSString *str=[[totalArray objectAtIndex:[indexPath row]] objectForKey:@"poi_content"];
//    NSArray *array=[str componentsSeparatedByString:@","];
//    content.text=[[array objectAtIndex:0] stringByReplacingOccurrencesOfString:@"title:" withString:@""];
    NSString *str=[[totalArray objectAtIndex:[indexPath row]] objectForKey:@"poi_content"];
//    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *nd=[str objectFromJSONString];
    content.text=[nd objectForKey:@"title"];
    [content sizeToFit];
    [cell.contentView addSubview:content];
    
    UILabel *time=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, content.frame.size.height+content.frame.origin.y, 200.0, 25.0)] autorelease];
    time.numberOfLines=1;
    time.textColor=[UIColor whiteColor];
    time.backgroundColor=[UIColor clearColor];
    time.text=[UIHelper TimeFormat:[[[totalArray objectAtIndex:[indexPath row]] objectForKey:@"last_modify_timestamp"] longLongValue]];
    [cell.contentView addSubview:time];
    
    UIView *speview=[[[UIView alloc] initWithFrame:CGRectMake(0.0, time.frame.origin.y+time.frame.size.height+3.0f, 320.0,1)] autorelease];
    speview.backgroundColor=[UIColor colorWithRed:12.0/255.0 green:20.0/255.0 blue:37.0/255.0 alpha:0.8];
    [cell.contentView addSubview:speview];
    //设置高度
    CGFloat height=speview.frame.origin.y+speview.frame.size.height+3.0f;
    CGRect rect=CGRectMake(0.0f, 0.0f, cell.bounds.size.width, height);
    cell.bounds=rect;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(deleteDataInThread:) toTarget:self withObject:[NSNumber numberWithInt:[indexPath row]]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
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
    [totalArray release];
    totalArray=nil;
    [super dealloc];
}

@end
