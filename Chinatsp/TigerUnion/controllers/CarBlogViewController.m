//
//  CarBlogViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-17.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "CarBlogViewController.h"
#import "NetService.h"
#import "UIHelper.h"
#import "JSONKit.h"
#import "BlogAlertView.h"
#import "LoadingMoreFooterView.h"
#import "AddBlogViewController.h"
#import "Blog.h"
#import "config.h"

@interface CarBlogViewController ()

@end

@implementation CarBlogViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        pageNum=0;
        isLastPage=NO;
        self.hidesBottomBarWhenPushed=YES;
        totalarray=[[NSMutableArray alloc] init];
        isLoad=NO;
        isShownet=NO;
        self.title=@"车博";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadBG];
    [self loadHeaderView];
    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
//    title.textColor = [UIColor redColor];
//    title.text = @"车博";
//    title.textAlignment = UITextAlignmentCenter;
//    title.font = [UIFont boldSystemFontOfSize:18];
//    title.backgroundColor = [UIColor clearColor];
//    self.navigationItem.titleView = title;

//    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
//    self.view.backgroundColor=[UIColor blackColor];
//    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
//    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editClick)] autorelease];
    [self initViews];
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(getTableListInThread) toTarget:self withObject:nil];
	// Do any additional setup after loading the view.
}

- (void)loadBG
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, 320, [MyUtil viewHeight] - 45)];
    bg.image = [UIImage imageNamed:@"bg_subviews"];
    [self.view addSubview:bg];
    [bg release];
}

- (void)loadHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    navi.image = [UIImage imageNamed:@"wash"];
    [self.view addSubview:navi];
    [navi release];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(4, 4, 60, 38)];
    [leftBtn setImage:[UIImage imageNamed:@"btn_back_home"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:leftBtn];
    
    [self.view addSubview:header];
    
    [header release];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initViews
{
//    UIView *bg=[[UIView alloc] initWithFrame:CGRectMake(0.0,0.0, 320.0, 460.0-44.0+(iPhone5?88:0))];
//    if(iPhone5)
//    {
//        bg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg-568h"]];
//    }else
//    {
//        bg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
//    }
//    [self.view addSubview:bg];
//    [bg release];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 48.0, 320.0, 460.0 - 44.0+(iPhone5 ? 88 : 0))];
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
    
    _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - table.bounds.size.height, self.view.frame.size.width, table.bounds.size.height) identify:@"blogLastTime"];
    _refreshHeaderView.delegate=self;
    [table addSubview:_refreshHeaderView];
    [_refreshHeaderView release];
    
    [_refreshHeaderView getLastUpdatedDate:@"blogLastTime"];
    
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
    NSData *data=[[NetService singleHttpService] getCarBlogList:15*pageNum type:@"1"];
    [self performSelectorOnMainThread:@selector(getResult:) withObject:data waitUntilDone:NO];
}

-(void)getResult:(NSData *)data
{
    [self closeProgressDialog];
    isLoad=NO;
    if(data)
    {
        NSDictionary *nd=[data objectFromJSONData];
        //NSLog(@"----%@",nd);
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

-(void)editClick
{
    AddBlogViewController *add=[[AddBlogViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
    [add release];
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
    NSData *data=[[NetService singleHttpService] getCarBlogList:0 type:@"1"];
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
    
    UILabel *content=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 300.0, 25.0)] autorelease];
    content.numberOfLines=0;
    content.textColor=[UIColor blackColor];
    content.backgroundColor=[UIColor clearColor];
    content.text=[[totalarray objectAtIndex:[indexPath row]] objectForKey:@"content"];
    [content sizeToFit];
    [cell.contentView addSubview:content];
    
    UILabel *time=[[[UILabel alloc] initWithFrame:CGRectMake(170.0, content.frame.size.height+content.frame.origin.y, 130.0, 25.0)] autorelease];
    time.numberOfLines=1;
    time.textColor=[UIColor colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0];
    time.font=[UIFont systemFontOfSize:12.0];
    time.backgroundColor=[UIColor clearColor];
    time.text=[[totalarray objectAtIndex:[indexPath row]] objectForKey:@"release_time"];
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

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//    
//    if([totalarray count]==0)
//    {
//        return;
//    }
//    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
//    if(bottomEdge>=floor(scrollView.contentSize.height)&&!isLoad&&!isLastPage)
//    {
//        self.loadFooterView.showActivityIndicator=YES;
//        isLoad=YES;
//        pageNum++;
//        NSThread *thread=[[[NSThread alloc] initWithTarget:self selector:@selector(getTableListInThread) object:nil] autorelease];
//        [thread start];
//    }
//}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    if([totalArray count]==0)
    //    {
    //        return;
    //    }
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

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//	
//	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//}

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
