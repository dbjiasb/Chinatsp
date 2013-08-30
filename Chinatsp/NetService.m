//
//  NetService.m
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import "NetService.h"
#import "config.h"
#import "MyDefaults.h"
#import "Collect.h"
#import "Blog.h"
#import "UIHelper.h"

static NetService *netservice=nil;
@implementation NetService

+(NetService *)singleHttpService
{
    @synchronized(netservice)
    {
        if(!netservice)
        {
            netservice=[[NetService alloc] init];
        }
    }
    return netservice;
}

-(NSData *)loginByNameAndPasswd:(NSString *)user password:(NSString *)pwd imei:(NSString *)uuid
{
    NSString *postUrl=[NSString stringWithFormat:@"uuid=%@&password=%@",user,pwd];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[postUrl length]];
    NSString *newLoginUrl=[LoginUrl stringByReplacingOccurrencesOfString:@"IMEI" withString:uuid];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:newLoginUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postUrl dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getCarList:(NSString *)uuid
{
    NSString *newCarUrl=[CarListUrl stringByReplacingOccurrencesOfString:@"UUID" withString:uuid];
    NSURL *url=[NSURL URLWithString:newCarUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)logout:(NSString *)uuid
{
    NSString *newLoginUrl=[LoginUrl stringByReplacingOccurrencesOfString:@"IMEI" withString:uuid];
    NSLog(@"-----%@",newLoginUrl);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:newLoginUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request setHTTPMethod:@"DELETE"];
//    [request addValue:[MyDefaults getToken] forHTTPHeaderField:@"access_token"];
//    [request addValue:[UIHelper getOpenUDID] forHTTPHeaderField:@"customer_key"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getUserInfo
{
    NSString *newUserInfoUrl=[UserInfoUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSURL *url=[NSURL URLWithString:newUserInfoUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)updateUserInfo:(NSString *)str method:(NSString *)str1
{
    NSString *postUrl=[NSString stringWithFormat:@"%@=%@&_api_accept_type_=%@",str1,str,@"json"];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[postUrl length]];
    NSString *newUpdateUrl=[UpdateInfoUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUpdateUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postUrl dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getCarInfo
{
    NSString *carInfo=[CarInfoUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSString *newCarInfo=[carInfo stringByReplacingOccurrencesOfString:@"TUID" withString:[MyDefaults getTuid]];
    NSURL *url=[NSURL URLWithString:newCarInfo];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)updateCarInfo:(NSString *)str method:(NSString *)str1
{
    NSString *postUrl=[NSString stringWithFormat:@"%@=%@",str1,str];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[postUrl length]];
    NSString *newCarUrl=[CarInfoUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSString *newUpdateUrl=[newCarUrl stringByReplacingOccurrencesOfString:@"TUID" withString:[MyDefaults getTuid]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUpdateUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postUrl dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getCarCondition
{
    NSString *newDUrl=[DiagnosisUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSString *newUrl=[newDUrl stringByReplacingOccurrencesOfString:@"TUID" withString:[MyDefaults getTuid]];
    NSURL *url=[NSURL URLWithString:newUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)sendDiagnosis:(int)start
{
    NSString *posturl=[NSString stringWithFormat:@"&start=%d&rows=15&type=0",start];
    NSString *newUUrl=[DiagnosisUrl1 stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSString *newtUrl=[newUUrl stringByReplacingOccurrencesOfString:@"TUID" withString:[MyDefaults getTuid]];
    NSString *newUrl=[newtUrl stringByAppendingString:posturl];
    NSURL *url=[NSURL URLWithString:newUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getFourSList:(int)start
{
    NSString *posurl=[NSString stringWithFormat:@"&start=%d&rows=15",start];
    NSString *newUrl=[FourSListURL stringByAppendingString:posurl];
    NSURL *url=[NSURL URLWithString:newUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getHost
{
    NSString *newDUrl=[PeccancyUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSURL *url=[NSURL URLWithString:newDUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)queryViolationList:(NSString *)host carNum:(NSString *)carnum carEngineNum:(NSString *)carenginenum
{
    NSString *url1=[HostUrl stringByReplacingOccurrencesOfString:@"HOST" withString:host];
    NSString *url2=[url1 stringByReplacingOccurrencesOfString:@"VEH_NO" withString:carnum];
    NSString *url3=[url2 stringByReplacingOccurrencesOfString:@"ENGINE_NO" withString:carenginenum];
    NSLog(@"=====%@",url3);
    NSURL *url=[NSURL URLWithString:url3];
    NSURLRequest *request=[[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0] autorelease];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)sendCommantBywake:(NSString *)wake
{    
    NSString *postUrl=[NSString stringWithFormat:@"type=%@&_api_accept_type_=%@&is_instant=%@&content=%@",wake,@"json",@"1",@""];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[postUrl length]];
    NSString *newCarUrl=[CommandUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSString *newUpdateUrl=[newCarUrl stringByReplacingOccurrencesOfString:@"TUID" withString:[MyDefaults getTuid]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUpdateUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postUrl dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)sendCommantBystatus:(NSString *)status
{
    NSString *postUrl=[NSString stringWithFormat:@"type=%@&_api_accept_type_=%@&is_instant=%@&content=%@",status,@"json",@"1",@""];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[postUrl length]];
    NSString *newCarUrl=[CommandUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSString *newUpdateUrl=[newCarUrl stringByReplacingOccurrencesOfString:@"TUID" withString:[MyDefaults getTuid]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUpdateUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postUrl dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getLocation
{
    NSString *newDUrl=[GetLocationUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSString *newUrl=[newDUrl stringByReplacingOccurrencesOfString:@"TUID" withString:[MyDefaults getTuid]];
    NSURL *url=[NSURL URLWithString:newUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getcommentList
{
    NSURL *url=[NSURL URLWithString:getCommentListUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request setHTTPMethod:@"GET"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getWeatherInfo
{
    NSString *weatherurl=[getWeatherUrl stringByAppendingString:@"北京"];
    NSString *encodevalue=[weatherurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:encodevalue] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0] autorelease];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getCarBlogList:(int)start type:(NSString *)type
{
    NSString *postUrl=[NSString stringWithFormat:@"&type=%@&start=%d&rows=15",type,start];
    //NSString *msgLength=[NSString stringWithFormat:@"%d",[postUrl length]];
    NSString *newCarUrl=[getBlogListUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSString *newUrl=[newCarUrl stringByAppendingString:postUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
//    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"GET"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    //[request setHTTPBody:[postUrl dataUsingEncoding:NSUTF8StringEncoding]];
//     NSURLRequest *request=[[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0] autorelease];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)insertBlog:(Blog *)blog time:(NSString *)time type:(NSString *)type
{
    NSString *postUrl=nil;
    if([@"1" isEqualToString:type])
    {
        postUrl=[NSString stringWithFormat:@"content=%@&release_time=%@&type=%@",blog.brief,time,type];
    }else
    {
        NSString *str=[NSString stringWithFormat:@"{\"title\":\"%@\",\"time\":\"%@\",\"brief\":\"%@\",\"from\":\"%@\",\"description\":\"%@\",\"originator_name\":\"%@\",\"phone_number\":\"%@\"}",blog.title,blog.time,blog.brief,blog.from,blog.description,blog.name,blog.phone];
        postUrl=[NSString stringWithFormat:@"content=%@&release_time=%@&type=%@",str,time,type];
    }
    NSString *msgLength=[NSString stringWithFormat:@"%d",[postUrl length]];
    NSString *blogurl=[getBlogListUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSURL *url=[NSURL URLWithString:blogurl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    [request setHTTPBody:[postUrl dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)insertClouy:(Collect *)collect
{
    NSString *str=[NSString stringWithFormat:@"{\"title\":\"%@\",\"lat\":\"%f\",\"lng\":\"%f\",\"description\":\"%@\"}",collect.title,collect.lat,collect.lon,@""];
    NSString *postUrl=[NSString stringWithFormat:@"poi_content=%@",str];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[postUrl length]];
    NSString *newInsertUrl=[InsertClouyUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:newInsertUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postUrl dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getCollectList
{
    return [self getCollectListWithType:0];
}

-(NSData *)getCollectListWithType:(int )type
{
    NSString *newInsertUrl = [getColloectListUrl stringByReplacingOccurrencesOfString:@"UUID" withString:/*[MyDefaults getUserName]*/@"23285"];
    if(type != 0)
    {
        newInsertUrl = [NSString stringWithFormat:@"%@&type=%d",newInsertUrl,type];
    }
    NSLog(@"%@",newInsertUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newInsertUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    [request setHTTPMethod:@"GET"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data) {
        NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"%@",string);
    }

    return data;

}

-(NSData *)deleteCollect:(NSString *)poiid
{
    NSString *collecturl=[EditColloectListUrl stringByReplacingOccurrencesOfString:@"UUID" withString:[MyDefaults getUserName]];
    NSString *newcollecturl=[collecturl stringByReplacingOccurrencesOfString:@"POI_ID" withString:poiid];
    NSURL *url=[NSURL URLWithString:newcollecturl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request setHTTPMethod:@"DELETE"];
    [request addValue:[NSString stringWithFormat:@"access_token=%@;customer_key=%@",[MyDefaults getToken],[UIHelper getOpenUDID]] forHTTPHeaderField:@"cookie"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getIllegalList:(NSString *)carorg lstype:(NSString *)lstype lsprefix:(NSString *)lsprefix lsnum:(NSString *)lsnum engineno:(NSString *)engineno frameno:(NSString *)frameno imgcode:(NSString *)imgcode cookie:(NSString *)cookie
{
    NSString *posturl=[NSString stringWithFormat:@"carorg=%@&lstype=%@&lsprefix=%@&lsnum=%@&engineno=%@&imgcode=%@&frameno=%@&cookie=%@",carorg,lstype,lsprefix,lsnum,engineno,imgcode,frameno,cookie];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[posturl length]];
    NSURL *url=[NSURL URLWithString:@"http://m.46644.com/tool/illegal/?act=query&cookieby=url"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request setHTTPBody:[posturl dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

-(NSData *)getInditify:(NSString *)traffic
{
    NSString *posturl=[NSString stringWithFormat:@"http://m.46644.com/tool/illegal/?act=img&carorg=%@&cookieby=url",traffic];
    NSURL *url=[NSURL URLWithString:posturl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}

@end
