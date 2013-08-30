//
//  ActivityViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-17.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//
#define ExitBtnTag 101
#define EditBtnTag 102

#import "ActivityViewController.h"
#import "NetService.h"
#import "UIHelper.h"
#import "JSONKit.h"
#import "LoadingMoreFooterView.h"
#import "config.h"
#import "AddActivityViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"活动";
        pageNum=0;
        isLastPage=false;
        selectFlag=-1;
        totalarray=[[NSMutableArray alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        isLoad=NO;
        isShownet=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"添加活动" style:UIBarButtonItemStyleBordered target:self action:@selector(addClick)] autorelease];
    [self initViews];
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(getTableListInThread) toTarget:self withObject:nil];
	// Do any additional setup after loading the view.
}
-(void)initViews
{
    UIView *bg=[[UIView alloc] initWithFrame:CGRectMake(0.0,0.0, 320.0, 460.0-44.0+(iPhone5?88:0))];
    if(iPhone5)
    {
        bg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg-568h"]];
    }else
    {
        bg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    }
    [self.view addSubview:bg];
    [bg release];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake((320.0-304.5)/2,0.0, 304.5, 460.0-70.5-44.0+(iPhone5?88:0))];
    table.delegate=self;
    table.dataSource=self;
    table.separatorStyle=NO;
    table.backgroundColor=[UIColor clearColor];
    [self.view addSubview:table];
    [table release];
    
    self.loadFooterView=[[[LoadingMoreFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 20.0f)] autorelease];
    self.loadFooterView.backgroundColor=[UIColor clearColor];
    table.tableFooterView=self.loadFooterView;
    [table.tableFooterView setHidden:YES];
    
    _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - table.bounds.size.height, self.view.frame.size.width, table.bounds.size.height) identify:@"activityLastTime"];
    _refreshHeaderView.delegate=self;
    [table addSubview:_refreshHeaderView];
    [_refreshHeaderView release];
    
    [_refreshHeaderView getLastUpdatedDate:@"activityLastTime"];
    
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

-(void)getTableListInThread
{
    NSData *data=[[NetService singleHttpService] getCarBlogList:15*pageNum type:@"2"];
    [self performSelectorOnMainThread:@selector(getResult:) withObject:data waitUntilDone:NO];
}

-(void)getResult:(NSData *)data
{
    [self closeProgressDialog];
    isLoad=NO;
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        if([@"OK" isEqualToString:[nd objectForKey:@"resp_status"]])
        {
            
            NSDictionary *blog=[nd objectForKey:@"resp_data"];
            if([@"" isEqualToString:[blog objectForKey:@"blog_list"]])
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
            }
            else
            {
                self.loadFooterView.showActivityIndicator=NO;
                NSArray *tempArray=[[blog objectForKey:@"blog_list"] allValues];
                [totalarray addObjectsFromArray:tempArray];
                if([totalarray count]<15)
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
        [self showNetAlertView];
        [self performSelector:@selector(hideNetAlertView) withObject:nil afterDelay:3.0];
    }
}

-(void)btnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)addClick
{
    AddActivityViewController *send=[[AddActivityViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:send];
    if([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
    [self presentModalViewController:nav animated:YES];
    [send release];
    [nav release];
}

-(void)cellBtn:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if(selectFlag==btn.tag)
    {
        selectFlag=-1;
        NSIndexPath *path=[NSIndexPath indexPathForRow:btn.tag inSection:0];
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
        //[table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else
    {
        int tempflag=selectFlag;
        selectFlag=-1;
        NSIndexPath *path=[NSIndexPath indexPathForRow:tempflag inSection:0];
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
        NSIndexPath *path1=[NSIndexPath indexPathForRow:btn.tag inSection:0];
        selectFlag=btn.tag;
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:path1] withRowAnimation:UITableViewRowAnimationFade];
        //[table scrollToRowAtIndexPath:path1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

-(void)refreshTableListInThread
{
    NSData *data=[[NetService singleHttpService] getCarBlogList:0 type:@"2"];
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
            [totalarray removeAllObjects];
            NSDictionary *blog=[nd objectForKey:@"resp_data"];
            if([@"" isEqualToString:[blog objectForKey:@"blog_list"]])
            {
                [UIHelper showAlertview:@"没有找到相关数据"];
            }else
            {
                NSArray *tempArray=[[blog objectForKey:@"blog_list"] allValues];
                [totalarray addObjectsFromArray:tempArray];
                if([totalarray count]<15)
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
    return [totalarray count];
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
    
    NSString *str=[[totalarray objectAtIndex:[indexPath row]] objectForKey:@"content"];
    NSDictionary *nd=[str objectFromJSONString];
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 100, 25.0)];
    title.numberOfLines=1;
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    title.text=[nd objectForKey:@"title"];
    [cell.contentView addSubview:title];
    [title release];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0.0, 0.0, 304.5, 45.0);
    [btn setImage:[UIImage imageNamed:@"head_bg"] forState:UIControlStateNormal];
    btn.tag=[indexPath row];
    [btn addTarget:self action:@selector(cellBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn];
    
    UILabel *sender=[[UILabel alloc] initWithFrame:CGRectMake(5.0, btn.frame.size.height+btn.frame.origin.y+5.0, 300.0, 25.0)];
    sender.numberOfLines=0;
    sender.textColor=[UIColor whiteColor];
    sender.backgroundColor=[UIColor clearColor];
    sender.text=[NSString stringWithFormat:@"发起人：%@",[nd objectForKey:@"originator_name"]];
    [sender sizeToFit];
    [cell.contentView addSubview:sender];
    [sender release];
    
    UILabel *content=[[UILabel alloc] initWithFrame:CGRectMake(5.0, sender.frame.size.height+sender.frame.origin.y, 300.0, 25.0)];
    content.numberOfLines=0;
    content.textColor=[UIColor whiteColor];
    content.backgroundColor=[UIColor clearColor];
    content.text=[NSString stringWithFormat:@"内容：%@",[nd objectForKey:@"brief"]];
    [content sizeToFit];
    [cell.contentView addSubview:content];
    [content release];
    
    UILabel *tel=[[UILabel alloc] initWithFrame:CGRectMake(5.0, content.frame.size.height+content.frame.origin.y, 300.0, 25.0)];
    tel.numberOfLines=0;
    tel.textColor=[UIColor whiteColor];
    tel.backgroundColor=[UIColor clearColor];
    tel.text=[NSString stringWithFormat:@"电话：%@",[nd objectForKey:@"phone_number"]];
    [tel sizeToFit];
    [cell.contentView addSubview:tel];
    [tel release];
    
    UILabel *startaddr=[[UILabel alloc] initWithFrame:CGRectMake(5.0, tel.frame.size.height+tel.frame.origin.y, 300.0, 25.0)];
    startaddr.numberOfLines=0;
    startaddr.textColor=[UIColor whiteColor];
    startaddr.backgroundColor=[UIColor clearColor];
    NSArray *array=[[nd objectForKey:@"from"] componentsSeparatedByString:@","];
    startaddr.text=[NSString stringWithFormat:@"出发地：%@",[array objectAtIndex:0]];
    [startaddr sizeToFit];
    [cell.contentView addSubview:startaddr];
    [startaddr release];
    
    UILabel *endaddr=[[UILabel alloc] initWithFrame:CGRectMake(5.0, startaddr.frame.size.height+startaddr.frame.origin.y, 300.0, 25.0)];
    endaddr.numberOfLines=0;
    endaddr.textColor=[UIColor whiteColor];
    endaddr.backgroundColor=[UIColor clearColor];
    endaddr.text=[NSString stringWithFormat:@"到达地：%@",[array objectAtIndex:1]];
    [endaddr sizeToFit];
    [cell.contentView addSubview:endaddr];
    [endaddr release];
    
    UILabel *time=[[UILabel alloc] initWithFrame:CGRectMake(170.0, endaddr.frame.size.height+endaddr.frame.origin.y, 130.0, 25.0)];
    time.numberOfLines=1;
    time.textColor=[UIColor colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0];
    time.font=[UIFont systemFontOfSize:12.0];
    time.backgroundColor=[UIColor clearColor];
    time.text=[[totalarray objectAtIndex:[indexPath row]] objectForKey:@"release_time"];
    [cell.contentView addSubview:time];
    [time release];
    
    if(selectFlag==[indexPath row])
    {
        [time setHidden:NO];
        [sender setHidden:NO];
        [content setHidden:NO];
        [tel setHidden:NO];
        [startaddr setHidden:NO];
        [endaddr setHidden:NO];
        [time setHidden:NO];
        [btn setImage:[UIImage imageNamed:@"diagnois_header"] forState:UIControlStateNormal];
        CGFloat height=time.frame.origin.y+time.frame.size.height+3.0f;
        CGRect rect=CGRectMake(0.0f, 0.0f, cell.bounds.size.width, height);
        cell.bounds=rect;
    }
    else{
        [time setHidden:YES];
        [sender setHidden:YES];
        [content setHidden:YES];
        [tel setHidden:YES];
        [startaddr setHidden:YES];
        [endaddr setHidden:YES];
        [time setHidden:YES];
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
        NSThread *thread=[[[NSThread alloc] initWithTarget:self selector:@selector(getTableListInThread) object:nil] autorelease];
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
    [totalarray release];
    totalarray=nil;
    self.loadFooterView=nil;
    [super dealloc];
}

@end
