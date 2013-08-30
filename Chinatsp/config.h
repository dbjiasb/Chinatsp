//
//  config.h
//  Chinatsp
//
//  Created by Bolu Lv on 13-3-22.
//  Copyright (c) 2013年 yuante.Yuan Wen. All rights reserved.
//

#ifndef Chinatsp_config_h
#define Chinatsp_config_h
#define BAIDUKEY @"93E2C57B9EA9DEDCF24216A222B3B50AA7DED0B6"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define LoginUrl @"http://tsp1.incall.cn/api/1.0/mp/IMEI/login/?_api_accept_type_=json"

#define CarListUrl @"http://tsp1.incall.cn/api/1.0/user/UUID/veh/tulist/?_api_accept_type_=json"

#define UserInfoUrl @"http://tsp1.incall.cn/api/1.0/user/UUID/inf/protected/?_api_accept_type_=json"

#define UpdateInfoUrl @"http://tsp1.incall.cn/api/1.0/user/UUID/inf/protected/"

#define CarInfoUrl @"http://tsp1.incall.cn/api/1.0/user/UUID/veh/tuinfo/TUID/?_api_accept_type_=json"

#define DiagnosisUrl @"http://tsp1.incall.cn/api/1.0/user/UUID/veh/condition/TUID/?_api_accept_type_=json"

#define DiagnosisUrl1 @"http://tsp1.incall.cn/api/1.0/user/UUID/veh/ori_cond_batch/TUID/?_api_accept_type_=json"

#define FourSListURL @"http://tsp1.incall.cn/api/1.0/4s/4slist/?_api_accept_type_=json"

#define PeccancyUrl  @"http://tsp1.incall.cn/api/1.0/user/UUID/ap/APINNOV015/?_api_accept_type_=json"

#define HostUrl  @"http://HOST/ap015/api/1.0/mp/peccancy?veh_no=VEH_NO&engine_no=ENGINE_NO&_api_accept_type_=json"

#define CommandUrl  @"http://tsp1.incall.cn/api/1.0/user/UUID/im/tu/TUID/"

#define GetLocationUrl @"http://tsp1.incall.cn/api/1.0/user/UUID/lbs/current/TUID/?_api_accept_type_=json"

#define getCommentListUrl  @"http://tsp1.incall.cn/api/1.0/mp/tips/?_api_accept_type_=json"

#define getWeatherUrl   @"http://ap.chinatsp.com/ap004/api/1.0/tu/getweather?city="

#define getBlogListUrl @"http://tsp1.incall.cn/api/1.0/user/UUID/blog/?_api_accept_type_=json"

#define InsertClouyUrl  @"http://tsp1.incall.cn/api/1.0/user/UUID/lbs/poi/?_api_accept_type_=json"

#define getColloectListUrl @"Http://tsp1.incall.cn/api/1.0/user/UUID/lbs/poi/?_api_accept_type_=json"

#define EditColloectListUrl @"Http://tsp1.incall.cn/api/1.0/user/UUID/lbs/poi/POI_ID/?_api_accept_type_=json"

#endif
