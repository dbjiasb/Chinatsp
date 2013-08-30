//
//  UIHelper.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#define WAKE @"WAKE"

#import <Foundation/Foundation.h>

@interface UIHelper : NSObject
+(void)showAlertview:(NSString *)message;
+(BOOL)stringIsEmptyOrIsNull:(NSString *)text;
+(NSString *)TimeFormat:(long)time;
+(NSString *)getOpenUDID;
+(BOOL)checkNetIsConnect;
@end
