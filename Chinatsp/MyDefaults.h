//
//  MyDefaults.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDefaults : NSObject

+(void)setUserName:(NSString *)username;
+(NSString *)getUserName;
+(void)setPwd:(NSString *)pwd;
+(NSString *)getPwd;
+(void)setTuid:(NSString *)tuid;
+(NSString *)getTuid;
+(void)setToken:(NSString *)token;
+(NSString *)getToken;
@end
