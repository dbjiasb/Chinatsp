//
//  ChinaTspDap.h
//  Chinatsp
//
//  Created by yuante on 13-4-12.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@class CarStatus;
@interface ChinaTspDao : NSObject

+(ChinaTspDao *)singleDao;

-(FMDatabase *)createDataBase;
-(BOOL)insertCarInfo:(CarStatus *)carstatus;
-(BOOL)deleteCarInfo;
-(CarStatus *)LoadCarInfo;
@end
