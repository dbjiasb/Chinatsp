//
//  CommentViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-14.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "CommentViewController.h"
#import "NetService.h"
#import "UIHelper.h"
#import "JSONKit.h"
#import "config.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"爱车小常识";
        totalArray=[[NSMutableArray alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        selectFlag=-1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    [self initViews];
    [self createProgressDialog];
    [NSThread detachNewThreadSelector:@selector(getDataInthread) toTarget:self withObject:nil];
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    UIView *commentbg=[[UIView alloc] initWithFrame:CGRectMake(0.0,0.0, 320.0, 460.0-44.0+(iPhone5?88:0))];
    if(iPhone5)
    {
        commentbg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg-568h"]];
    }else
    {
        commentbg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    }
    [self.view addSubview:commentbg];
    [commentbg release];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake((320.0-304.5)/2, 0.0, 304.5, 460.0-44.0-70.5+(iPhone5?88:0)) style:UITableViewStylePlain];
    table.backgroundColor=[UIColor clearColor];
    table.separatorStyle=NO;
    table.dataSource=self;
    table.delegate=self;
    table.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.05];
    [commentbg addSubview:table];
    [table release];
}

-(void)btnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)getDataInthread
{
    NSData *data=[[NetService singleHttpService] getcommentList];
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
            if([@"" isEqualToString:[[nd objectForKey:@"resp_data"] objectForKey:@"tips_list"]])
            {
                [UIHelper showAlertview:@"没有找到相关数据"];
            }else
            {
                NSDictionary *nd1=[[nd objectForKey:@"resp_data"] objectForKey:@"tips_list"];
                [totalArray setArray:[nd1 allValues]];
                [table reloadData];
            }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [totalArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]==selectFlag)
    {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;

    }else
    {
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity] autorelease];
    }
    for(UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *nd=[totalArray objectAtIndex:[indexPath row]];
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 100, 25.0)];
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    title.text=[nd objectForKey:@"title"];
    [title sizeToFit];
    [cell.contentView addSubview:title];
    [title release];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0.0, 0.0, 304.5, 45.0);
    [btn setImage:[UIImage imageNamed:@"head_bg"] forState:UIControlStateNormal];
    btn.tag=[indexPath row];
    [btn addTarget:self action:@selector(cellBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn];
    
    UILabel *contentlabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, btn.frame.size.height+btn.frame.origin.y, 304.5, 25.0)];
    contentlabel.numberOfLines=0;
    contentlabel.textColor=[UIColor whiteColor];
    contentlabel.backgroundColor=[UIColor clearColor];
    contentlabel.text=[nd objectForKey:@"content"];
    [contentlabel sizeToFit];
    [cell.contentView addSubview:contentlabel];
    [contentlabel release];
    
    if(selectFlag==[indexPath row])
    {
        [contentlabel setHidden:NO];
        [btn setImage:[UIImage imageNamed:@"diagnois_header"] forState:UIControlStateNormal];
        //设置高度
        CGFloat height=contentlabel.frame.origin.y+contentlabel.frame.size.height+3.0f;
        CGRect rect=CGRectMake(0.0f, 0.0f, cell.bounds.size.width, height);
        cell.bounds=rect;
    }
    else{
        [btn setImage:[UIImage imageNamed:@"head_bg"] forState:UIControlStateNormal];
        [contentlabel setHidden:YES];
        cell.bounds=CGRectMake(0.0f, 0.0f, cell.bounds.size.width, 50.0);
    }
    return cell;
}


-(void)dealloc
{
    [totalArray release];
    totalArray=nil;
    [super dealloc];
}

@end
