//
//  AboutViewController.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-26.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "AboutViewController.h"
#import "config.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"软件信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:(iPhone5?@"home_bg-568h":@"home_bg")]];
    UITableView *table=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0-44.0+(iPhone5?88:0)) style:UITableViewStyleGrouped];
    table.dataSource=self;
    table.delegate=self;
    table.backgroundView=nil;
    [self.view addSubview:table];
    [table release];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    cell.textLabel.text=nil;
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if([indexPath row]==0)
    {
        cell.textLabel.text=@"版本:";
        UILabel *softversion=[[[UILabel alloc] initWithFrame:CGRectMake(75.0, 2.0, 200.0, 40.0)] autorelease];
        softversion.backgroundColor=[UIColor clearColor];
        [softversion setText:@"1.0"];
        [cell.contentView addSubview:softversion];
    }
    else if ([indexPath row]==1)
    {
        cell.textLabel.text=@"电话：";
        UILabel *mobile=[[[UILabel alloc] initWithFrame:CGRectMake(75.0, 2.0, 200.0, 40.0)] autorelease];
        mobile.backgroundColor=[UIColor clearColor];
        [mobile setText:@"18668093217"];
        [cell.contentView addSubview:mobile];
    }
    else if ([indexPath row]==2)
    {
        cell.textLabel.text=@"邮箱：";
        UILabel *email=[[[UILabel alloc] initWithFrame:CGRectMake(75.0, 2.0, 180.0, 40.0)] autorelease];
        email.backgroundColor=[UIColor clearColor];
        [email setText:@"wjzht7215@sina.com"];
        [cell.contentView addSubview:email];
    }
    else if ([indexPath row]==3)
    {
        cell.textLabel.text=@"网址：";
        UILabel *netaddr=[[[UILabel alloc] initWithFrame:CGRectMake(75.0, 2.0, 180.0, 40.0)] autorelease];
        netaddr.backgroundColor=[UIColor clearColor];
        [netaddr setText:@"www.chinatsp.com"];
        [cell.contentView addSubview:netaddr];
    }
    return cell;
}

-(void)dealloc
{
    [super dealloc];
}

@end
