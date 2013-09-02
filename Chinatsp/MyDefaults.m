//
//  MyDefaults.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "MyDefaults.h"

@implementation MyDefaults

+(void)setUserName:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getUserName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"] ? [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"] : @"23285";
}

+(void)setPwd:(NSString *)pwd
{
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"Pwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getPwd
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"Pwd"];
}

+(void)setTuid:(NSString *)tuid
{
    [[NSUserDefaults standardUserDefaults] setObject:tuid forKey:@"TUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getTuid
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"TUID"];
}

+(void)setToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"Token"];
}
@end
