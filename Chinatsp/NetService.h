//
//  NetService.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Collect;
@class Blog;

@interface NetService : NSObject

+(NetService *)singleHttpService;
-(NSData *)loginByNameAndPasswd:(NSString *)user password:(NSString *)pwd imei:(NSString *)uuid;
-(NSData *)getCarList:(NSString *)uuid;
-(NSData *)logout:(NSString *)uuid;
-(NSData *)getUserInfo;
-(NSData *)updateUserInfo:(NSString *)str method:(NSString *)str1
;
-(NSData *)getCarInfo;
-(NSData *)updateCarInfo:(NSString *)str method:(NSString *)str1;
-(NSData *)getCarCondition;
-(NSData *)sendDiagnosis:(int)start;
-(NSData *)getFourSList:(int)start;
-(NSData *)getHost;
-(NSData *)queryViolationList:(NSString *)host carNum:(NSString *)carnum carEngineNum:(NSString *)carenginenum;
-(NSData *)sendCommantBywake:(NSString *)wake;
-(NSData *)sendCommantBystatus:(NSString *)status;
-(NSData *)getLocation;
-(NSData *)getcommentList;
-(NSData *)getWeatherInfo;
-(NSData *)getCarBlogList:(int)start type:(NSString *)type;
-(NSData *)insertClouy:(Collect *)collect;
-(NSData *)getCollectList;
-(NSData *)getCollectListWithType:(int )type;
-(NSData *)deleteCollect:(NSString *)poiid;
-(NSData *)insertBlog:(Blog *)blog time:(NSString *)time type:(NSString *)type;
-(NSData *)getIllegalList:(NSString *)carorg lstype:(NSString *)lstype lsprefix:(NSString *)lsprefix lsnum:(NSString *)lsnum engineno:(NSString *)engineno frameno:(NSString *)frameno imgcode:(NSString *)imgcode cookie:(NSString *)cookie;
-(NSData *)getInditify:(NSString *)traffic;
@end
