//
//  LstypeListViewController.m
//  ChangAn
//
//  Created by yuante on 13-7-3.
//  Copyright (c) 2013年 yuante. All rights reserved.
//

#import "illegalCategoryViewController.h"
#import "config.h"

@interface illegalCategoryViewController ()

@end

@implementation illegalCategoryViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
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
    lstypenames=[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LstypeName.plist" ofType:nil]];
    lstypevalues=[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LstypeValue.plist" ofType:nil]];
    carorgnames=[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CarorgName.plist" ofType:nil]];
    carorgvalues=[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CarorgValue.plist" ofType:nil]];
    lsprefix=[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Lsprefix.plist" ofType:nil]];
	UITableView *table=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0-70.5+(iPhone5?88:0)) style:UITableViewStylePlain];
    table.backgroundColor=[UIColor clearColor];
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
    [table release];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarAppear" object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.flag==0)
    {
        return [carorgnames count];
    }
    else if (self.flag==1)
    {
        return [lstypenames count];
    }
    else if(self.flag==2)
    {
        return [lsprefix count];
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentify];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify] autorelease];
    }
    cell.textLabel.textColor=[UIColor whiteColor];
    if(self.flag==0)
    {
        cell.textLabel.text=[carorgnames objectAtIndex:[indexPath row]];
    }
    else if (self.flag==1)
    {
        cell.textLabel.text=[lstypenames objectAtIndex:[indexPath row]];
    }
    else if (self.flag==2)
    {
        cell.textLabel.text=[lsprefix objectAtIndex:[indexPath row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.flag==0)
    {
        [self.delegate getCarorg:[carorgnames objectAtIndex:[indexPath row]] value:[carorgvalues objectAtIndex:[indexPath row]]];
    }
    else if (self.flag==1)
    {
        [self.delegate getLstype:[lstypenames objectAtIndex:[indexPath row]] value:[lstypevalues objectAtIndex:[indexPath row]]];
    }
    else if (self.flag==2)
    {
        [self.delegate getLsprefix:[lsprefix objectAtIndex:[indexPath row]]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [lstypenames release];
    [lstypevalues release];
    [carorgvalues release];
    [carorgnames release];
    [lsprefix release];
    [super dealloc];
}

@end
