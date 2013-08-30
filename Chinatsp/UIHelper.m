//
//  UIHelper.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "UIHelper.h"
#import "OpenUDID.h"
#import "Reachability.h"

@implementation UIHelper
+(void)showAlertview:(NSString *)message
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

+(BOOL)stringIsEmptyOrIsNull:(NSString *)text
{
    if([[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(NSString *)TimeFormat:(long)time
{
    NSDateFormatter *dateformatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSString *currenttime=[dateformatter stringFromDate:date];
    return currenttime;
}

+(NSString *)getOpenUDID
{
    return [OpenUDID value];
}

+(BOOL)checkNetIsConnect
{
    BOOL isExistenceNetwork = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=NO;
            //   NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=YES;
            //   NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=YES;
            //  NSLog(@"正在使用wifi网络");
            break;
    }
    return isExistenceNetwork;
}
@end
