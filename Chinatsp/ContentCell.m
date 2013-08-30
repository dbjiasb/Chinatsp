//
//  ContentCell.m
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "ContentCell.h"

@implementation ContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contents:(NSArray *)contents
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.detailArr=contents;
        CGFloat height=[self.detailArr count]*45.0;
        CGRect rect=CGRectMake(0.0, 0.0, 304.5, height);
        [self setBoundsOfCell:rect];
        [self createDetailTableViewWithFrame:rect];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)createDetailTableViewWithFrame:(CGRect)frame
{
    detailTable=[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    detailTable.delegate=self;
    detailTable.dataSource=self;
    detailTable.scrollEnabled=NO;
    detailTable.separatorStyle=NO;
    detailTable.backgroundColor=[UIColor clearColor];
    [self addSubview:detailTable];
    [detailTable release];
}

-(void)setBoundsOfCell:(CGRect)bounds
{
    self.bounds=bounds;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.detailArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identitfy=@"subcell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identitfy];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identitfy] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    for(UIView *subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    UIImageView *cellbg=nil;
    if([indexPath row]==[self.detailArr count]-1)
    {
        cellbg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diagnois_bottom"]];
        cell.backgroundView=cellbg;
        [cellbg release];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(304.5-118.5-35.0, (45-41)/2, 118.5, 41.0);
        [btn setImage:[UIImage imageNamed:@"maintain_btn"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    else
    {
        cellbg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diagnois_middle"]];
        cell.backgroundView=cellbg;
        [cellbg release];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10.0, (45-30)/2, 250.0, 30)];
        label.backgroundColor=[UIColor clearColor];
        label.text=[self.detailArr objectAtIndex:[indexPath row]];
        label.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:label];
        [label release];
    }
    return cell;
}

-(void)btnClick:(id)sender
{
    [self.clickelegate selectBtnClick:sender];
}

-(void)dealloc
{
    self.detailArr=nil;
    [super dealloc];
}

@end
