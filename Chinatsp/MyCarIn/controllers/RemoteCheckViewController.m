//
//  RemoteCheckViewController.m
//  Chinatsp
//
//  Created by yuante on 13-8-30.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "RemoteCheckViewController.h"
#import "RemoteCheckCell.h"

@interface RemoteCheckViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation RemoteCheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _dataList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self loadBG];
    [self loadHeaderView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, 320, [TSPUtils viewHeight] - 48) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;

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

- (void)loadBG
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, 320, [TSPUtils viewHeight] - 45)];
    bg.image = [UIImage imageNamed:@"bg_subviews"];
    [self.view addSubview:bg];
    [bg release];
}

- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenty = @"RemoteCheckCell";
    RemoteCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    
    if (!cell) {
        cell = [RemoteCheckCell remoteCheckCell];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 206;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
