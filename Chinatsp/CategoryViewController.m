//
//  CategoryViewController.m
//  Chinatsp
//
//  Created by yuante on 13-4-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "CategoryViewController.h"
#import "UIHelper.h"
#import "PoiListViewController.h"
#import "config.h"
#import "AppDelegate.h"

@interface CategoryViewController ()
{
    AppDelegate *appDelegate;
}
@end

@implementation CategoryViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title=@"分类";
        categoryArray=[[NSArray alloc] initWithObjects:@"餐厅",@"酒店",@"公交站",@"银行",@"加油站",@"KTV",@"超市",@"ATM",@"电影院",@"洗浴",@"网吧",@"商场",@"银行", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
//    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    backbtn.frame=CGRectMake(5.0, (45.0-35.0)/2, 47.5, 35.0);
//    [backbtn setImage:[UIImage imageNamed:@"exit_btn"] forState:UIControlStateNormal];
//    [backbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(btnClick)] autorelease];
    self.view.backgroundColor=[UIColor blackColor];
    [self initViews];
    appDelegate=[[UIApplication sharedApplication] delegate];
//    self.mKSearch=[[[BMKSearch alloc] init] autorelease];
    //self.mKSearch.delegate=self;
//    [BMKSearch setPageCapacity:30];
	// Do any additional setup after loading the view.
}

-(void)initViews
{
    categoryTable=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0-44.0+(iPhone5?88:0)) style:UITableViewStylePlain];
    categoryTable.dataSource=self;
    categoryTable.delegate=self;
    categoryTable.separatorStyle=NO;
    categoryTable.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.05];
    [self.view addSubview:categoryTable];
    [categoryTable release];
}

-(void)btnClick
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)createProgressDialog
{
    UIView *bgview=[[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0,320.0, 460.0-44.0+(iPhone5?88:0))];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    appDelegate.mKSearch.delegate=self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    appDelegate.mKSearch.delegate=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoryArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    for(UIView *subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    UILabel *title=[[[UILabel alloc] initWithFrame:CGRectMake(5.0, 10.0, 100.0, 25.0)] autorelease];
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    title.text=[categoryArray objectAtIndex:[indexPath row]];
    [cell.contentView addSubview:title];
    
    UIImageView *arrow=[[[UIImageView alloc] initWithFrame:CGRectMake(280.0, 14.0, 7.5, 12.0)] autorelease];
    arrow.image=[UIImage imageNamed:@"arrow"];
    [cell.contentView addSubview:arrow];
    
    UIView *speview=[[[UIView alloc] initWithFrame:CGRectMake(0.0,40.0, 320.0,1.0)] autorelease];
    speview.backgroundColor=[UIColor colorWithRed:12.0/255.0 green:20.0/255.0 blue:37.0/255.0 alpha:0.8];
    [cell.contentView addSubview:speview];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLLocationCoordinate2D coor;
    coor.latitude=[self.latitude doubleValue];
    coor.longitude=[self.longitude doubleValue];
    [self createProgressDialog];
    selectTitle=[categoryArray objectAtIndex:[indexPath row]];
    [appDelegate.mKSearch poiSearchNearBy:[categoryArray objectAtIndex:[indexPath row]] center:coor radius:5000 pageIndex:0];
}

-(void) onGetPoiResult:(NSArray *)poiResultList searchType:(int)type errorCode:(int)error
{
    [self closeProgressDialog];
    if(error==BMKErrorOk)
    {
        BMKPoiResult* result = [poiResultList objectAtIndex:0];
        NSMutableArray *bmArray=[[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *annoArray=[[[NSMutableArray alloc] init] autorelease];
		for (int i = 0; i < result.poiInfoList.count; i++) {
			BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
			item.coordinate = poi.pt;
			item.title = poi.name;
            [annoArray addObject:item];
            [bmArray addObject:poi];
            [item release];
		}
        PoiListViewController *poi=[[PoiListViewController alloc] init];
        poi.listArray=bmArray;
        poi.title=selectTitle;
        poi.annoArray=annoArray;
        [self.navigationController pushViewController:poi animated:YES];
        [poi release];
    }
    else
    {
        [UIHelper showAlertview:@"查找失败"];
    }
}

-(void)dealloc
{
    [categoryArray release];
    categoryArray=nil;
    //self.mKSearch=nil;
    self.latitude=nil;
    self.longitude=nil;
    [super dealloc];
}

@end
