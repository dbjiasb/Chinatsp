//
//  eMarketingUtils.h
//  GD10000_eMarketing
//
//  Created by liu zhiliang on 13-1-21.
//  Copyright (c) 2013年 eshore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"

#define EVIEWWITHTAG(_OBJECT, _TAG)	[_OBJECT viewWithTag : _TAG]

#define RGBCOLOR(RED, GREEN, BLUE)	[UIColor colorWithRed : RED / 255.0 green : GREEN / 255.0 blue : BLUE / 255.0 alpha : 1.0]

#define EAutoTable(FRAME)			[[[UITableView alloc] initWithFrame:FRAME style:UITableViewStylePlain] autorelease];

#define EAutoGroupTable(FRAME)		[[[UITableView alloc] initWithFrame:FRAME style:UITableViewStyleGrouped] autorelease];

#define ESAFERelease(__pointer)		{ if (__pointer) { [__pointer release]; __pointer = nil; } }

#define theAppWindow	            [[UIApplication sharedApplication] keyWindow]
#define HUDTAG					    110000

#define EDefaultBgColor             [UIColor colorWithRed:249 green:249 blue:249 alpha:1.0f]

/*
 * nslog_debug
 */

#pragma mark - nslog_debug

#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...)
#endif

#pragma mark - 消息中心



#pragma mark -


#define ISNULL(__pointer)         (__pointer == nil || [[NSNull null] isEqual:__pointer])



BOOL isIphone5();

NSString * double2str(NSString * format, double num);

@interface TSPUtils : NSObject


+ (UIImage *)snapshot;

+ (float)IOSSystemVersion;

+ (BOOL)isIphone5;

+ (CGFloat)phoneHeight;

+ (CGFloat)viewHeight;

+ (CGFloat)navBarHeightWithController:(UIViewController *)target;

+ (CGRect)screenFrame;

+ (CGRect)viewFrame;

+ (NSString *)intFormatter:(int)longNumber;
+ (NSString *)doubleFormatter:(double)longNumber;
+ (NSString *)longLongFormatter:(long long)longNumber;
+ (NSString *)floatFormatter:(float)floatNumber;
+ (NSString *)numberFormatter:(NSNumber *)number;

/**
 net
 */

+ (BOOL)networkState;

+ (void)showAlertView:(NSString *)message;

+ (void)showMessageBox:(NSString *)message;
+ (void)dismissMessageBox;
+ (void)animateMessage:(NSString *)message;
/**
 Progress
 */
//+ (void)showMBHUD:(NSString *)message delegate:(id)delegate;
//+ (void)removeMBHUD;


/*
    把数据保存到document目录
 
    2013.4.23 by Ouyj
 */
+ (void)store2File:(NSData *)data fileName:(NSString *)name;

/*
    从document目录中读取文件，以数据返回。
    
    2013.4.23 by Ouyj
 */
+ (NSData *)fileFromStorageByFileName:(NSString *)name;

@end

#pragma mark - string Utils
@interface StringUtils : NSObject
+ (BOOL)isEmptyOrNull:(NSString *)string;
@end


#pragma mark - UIImage (GD10000_Utilities)

@interface UIImage (GD10000_Utilities)
+ (UIImage *)imageUtilName:(NSString *)name;
+ (UIImage *)imageJpgName:(NSString *)name;
/*
 * Stretchable image
 */
- (UIImage *)stretchableImage;
- (UIImage *)stretchableImageWithCenterSize:(CGSize)centerSize;
- (UIImage *)stretchableImageWithCapInsets:(UIEdgeInsets)capInsets;
- (UIImage *)scaleImageWithScale:(float)scaleSize;

- (long)fileSize;
@end

#pragma mark - UIButton (GD10000_Utilities)

@interface UIButton (GD10000_Utilities)

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;

- (void)setNormalTitle:(NSString *)normalTitle;
- (void)setHighlightedTitle:(NSString *)highlightedTitle;
- (void)setDisabledTitle:(NSString *)disabledTitle;
- (void)setSelectedTitle:(NSString *)selectedTitle;

- (void)setNormalImage:(UIImage *)normalImage;
- (void)setHighlightedImage:(UIImage *)highlightedImage;
- (void)setSelectedImage:(UIImage *)selectedImage;

- (void)setNormalBgImage:(UIImage *)normalBackgroundImage;
- (void)setHighlightedBgImage:(UIImage *)highlightedBackgroundImage;
- (void)setDisabledBgImage:(UIImage *)disabledBackgroundImage;
- (void)setSelectedBgImage:(UIImage *)selectedBackgroundImage;

- (void)setNormalTitleColor:(UIColor *)normalTitleColor;
- (void)setDisabledTitleColor:(UIColor *)normalTitleColor;
- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor;
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor;
- (void)setControlStateTitleColor:(UIColor *)stateTitleColor;

- (UIColor *)normalTitleShadowColor;
- (void)setNormalTitleShadowColor:(UIColor *)normalTitleShadowColor;
- (UIColor *)highlightedTitleShadowColor;
- (void)setHighlightedTitleShadowColor:(UIColor *)highlightedTitleShadowColor;
- (UIColor *)disabledTitleShadowColor;
- (void)setDisabledTitleShadowColor:(UIColor *)disabledTitleShadowColor;
- (UIColor *)selectedTitleShadowColor;
- (void)setSelectedTitleShadowColor:(UIColor *)selectedTitleShadowColor;

///add target/action for particular event.
- (void)touchUpInsideTarget:(id)target action:(SEL)action;
- (void)touchDownTarget:(id)target action:(SEL)action;
- (void)touchUpOutsideTarget:(id)target action:(SEL)action;
@end

#pragma mark - UIImageView (GD10000_Utilities)

@interface UIImageView (GD10000_Utilities)

- (void)setImageName:(NSString *)imageName;
@end


#pragma mark - NSString (GD10000_Utilities)

@interface NSString (GD10000_Utilities)

- (CGFloat)widthWithFont:(UIFont *)font;
- (CGFloat)heightWithFont:(UIFont *)font;

- (CGFloat)heightForLineWidth:(CGFloat)width font:(UIFont *)font;

- (BOOL)isEmptyOrNull;

- (NSString *)subStringAtLoc:(NSInteger)loc leng:(NSInteger)len;

/*
 
 NSString *string = @"Lots of cakes, with a piece of cake.";
 NSLog(@"Found %i",[string countOccurrencesOfSubstring:@"cakes"]);
 NSLog(@"Found %i",[string countOccurrencesOfSubstring:@"ca"]);
 NSLog(@"Found %i",[string countOccurrencesOfSubstring:@"cake"]);
 NSLog(@"Found %i",[string countOccurrencesOfSubstring:@"c"]);
 NSLog(@"Found %@",[string arrayOccurrencesOfSubstring:@"cake"]);
//*/

- (NSUInteger)countOccurrencesOfSubstring:(NSString *)substring;

- (NSArray *)arrayOccurrencesOfSubstring:(NSString *)substring;
@end

#pragma mark - UIView (GD10000_Utilities)

@interface UIView (GD10000_Utilities)

- (void)addSwipeWithTarget:(id)target action:(SEL)action;

@end

#pragma mark - NSDictionary (GD10000_Utilities)

@interface NSDictionary (GD10000_Utilities)

- (NSData *)GD10000_JSONData; ///jsonkit

@end
//*
#pragma mark - NSDate (GD10000_Utilities)

@interface NSDate (GD10000_Utilities)
- (NSString *)updateDate;
- (NSString *)formatCnDate;
- (NSString *)formatSampleDate;
- (NSString *)formatCnMDate;
- (NSString *)getFormatYearMonth;
- (NSString *)getFormatYearMonthDay;

- (int )getWeekNumOfMonth;
- (int )getWeekOfYear;

+ (NSDate *)beginningOfToday;
+ (NSDate *)dateAfterBeginningOfToday:(int)day;

- (NSDate *)dateAfterBeginningOfDay:(int)day;
- (NSDate *)dateAfterDay:(int)day;
- (NSDate *)dateAfterMonth:(int)month;

- (NSUInteger)getDay;
- (NSUInteger)getMonth;
- (NSUInteger)getYear;

- (int)getHour;
- (int)getMinute;

- (int)getHour:(NSDate *)date;
- (int)getMinute:(NSDate *)date;

- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;

- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;

- (NSUInteger)weekday;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSDate *)dateForYmd:(NSString *)string;
+ (NSDate *)dateForYm:(NSString *)string;
+ (NSDate *)dateFromUTCString:(NSString *)string;
+ (NSDate *)dateFromUTCString:(NSString *)string withFormat:(NSString *)format;

+ (NSString *)stringFromUTCDate:(NSDate *)date;
+ (NSString *)stringFromUTCDate1:(NSDate *)date;
+ (NSString *)stringFromUTCDate2:(NSDate *)date;
+ (NSString *)stringFromCNDate:(NSDate *)date;
+ (NSString *)stringFromUTCDate:(NSDate *)date withFormat:(NSString *)format;

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
- (NSString *)stringWithFormat:(NSString *)format;

- (NSString *)string;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)beginningOfMonth;
- (NSDate *)endOfMonth;
- (NSDate *)endOfWeek;

+ (NSString *)dateFormatString;
+ (NSString *)dateFormatString1;
+ (NSString *)timeFormatString;
+ (NSString *)yearMonth;
+ (NSString *)ymdFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;


@end

@interface UIDevice (UIDeviceAdditions)

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Returns the amount of memory which is currently used (in MB).
@property(readonly) double currentMemoryUsage;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSString*)platform;
- (NSString *)platformString;

@end


@interface UIColor (UIColorHex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
@end