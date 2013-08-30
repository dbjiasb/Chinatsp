//
//  ChinaTspDap.m
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "ChinaTspDao.h"
#import "FMDatabase.h"
#import "CarStatus.h"

@implementation ChinaTspDao


static ChinaTspDao *singleDao=nil;

+(ChinaTspDao *)singleDao
{
    @synchronized(singleDao)
    {
        if(!singleDao)
        {
            singleDao=[[ChinaTspDao alloc] init];
        }
    }
    return singleDao;
}

-(FMDatabase *)createDataBase
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[paths objectAtIndex:0];
    NSString *dbpath=[documentDirectory stringByAppendingPathComponent:@"ChinaTsp.db"];
    FMDatabase *db=[FMDatabase databaseWithPath:dbpath];
    if([db open])
    {
        [db executeUpdate:@"create table if not exists CarInfo(ishavetire integer,time integer,soil integer,left_up_door integer,left_down_door integer,right_up_door integer,right_down_door integer,left_up_tire integer,left_down_tire integer,right_up_tire integer,right_down_tire integer,dipped_beam_status integer,high_beam_status integer)"];
    }
    return db;
}

-(BOOL)insertCarInfo:(CarStatus *)carstatus
{
    FMDatabase *db=[self createDataBase];
    BOOL isscuess=[db executeUpdate:@"insert into  CarInfo values (?,?,?,?,?,?,?,?,?,?,?,?,?)",
                   [NSNumber numberWithInt:carstatus.isHaveTire],
                   [NSNumber numberWithInt:carstatus.data],
                   [NSNumber numberWithInt:carstatus.fuel],
                   [NSNumber numberWithInt:carstatus.left_up_door],
                   [NSNumber numberWithInt:carstatus.left_down_door],
                   [NSNumber numberWithInt:carstatus.right_up_door],
                   [NSNumber numberWithInt:carstatus.right_down_door],
                   [NSNumber numberWithInt:carstatus.left_up_tire_press],
                   [NSNumber numberWithInt:carstatus.left_down_tire_press],
                   [NSNumber numberWithInt:carstatus.right_up_tire_press],
                   [NSNumber numberWithInt:carstatus.right_down_tire_press],
                   [NSNumber numberWithInt:carstatus.dipped_beam_status],
                   [NSNumber numberWithInt:carstatus.high_beam_status]];
    [db close];
    return isscuess;
}

-(BOOL)deleteCarInfo
{
    FMDatabase *db=[self createDataBase];
    BOOL isscuess=[db executeUpdate:@"delete from CarInfo"];
    [db close];
    return isscuess;
}

-(CarStatus *)LoadCarInfo
{
    FMDatabase *db=[self createDataBase];
    CarStatus *carstatus=nil;
    FMResultSet *fs=[db executeQuery:@"select * from CarInfo"];
    if([fs next])
    {
        carstatus=[[[CarStatus alloc] init] autorelease];
        int ishavetire=[fs intForColumn:@"ishavetire"];
        int time=[fs intForColumn:@"time"];
        int soil=[fs intForColumn:@"soil"];
        int left_up_door=[fs intForColumn:@"left_up_door"];
        int left_down_door=[fs intForColumn:@"left_down_door"];
        int right_up_door=[fs intForColumn:@"right_up_door"];
        int right_down_door=[fs intForColumn:@"right_down_door"];
        int left_up_tire=[fs intForColumn:@"left_up_tire"];
        int left_down_tire=[fs intForColumn:@"left_down_tire"];
        int right_up_tire=[fs intForColumn:@"right_up_tire"];
        int right_down_tire=[fs intForColumn:@"right_down_tire"];
        int dipped_beam_status=[fs intForColumn:@"dipped_beam_status"];
        int high_beam_status=[fs intForColumn:@"high_beam_status"];
        carstatus.isHaveTire=ishavetire;
        carstatus.data=time;
        carstatus.fuel=soil;
        carstatus.left_up_door=left_up_door;
        carstatus.left_down_door=left_down_door;
        carstatus.right_up_door=right_up_door;
        carstatus.right_down_door=right_down_door;
        carstatus.left_up_tire_press=left_up_tire;
        carstatus.left_down_tire_press=left_down_tire;
        carstatus.right_up_tire_press=right_up_tire;
        carstatus.right_down_tire_press=right_down_tire;
        carstatus.dipped_beam_status=dipped_beam_status;
        carstatus.high_beam_status=high_beam_status;
    }
    [db close];
    return carstatus;
}
@end
