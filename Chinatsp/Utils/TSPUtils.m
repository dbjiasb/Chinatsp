//
//  eMarketingUtils.m
//  GD10000_eMarketing
//
//  Created by liu zhiliang on 13-1-21.
//  Copyright (c) 2013年 eshore. All rights reserved.
//

#import "TSPUtils.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <sys/sysctl.h>
#include <mach/mach.h>
#import <objc/runtime.h>
#import <netinet/in.h>
#import <sys/types.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import "AppDelegate.h"

BOOL isIphone5() {
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO);
}

NSString * double2str(NSString * format, double num) {
    if (num == 0) {
        return @"0";
    } else {
        return [NSString stringWithFormat:format, num];
    }
}

@interface TSPUtils ()  {
    
}

@end

@implementation TSPUtils


+ (void) initialize
{
    
    
}

- (void)dealloc {
    
    [super dealloc];
}

+ (UIImage *)snapshot
{
    
    UIGraphicsBeginImageContextWithOptions(theAppWindow.bounds.size, theAppWindow.opaque, 0.0);
    [theAppWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


+ (float)IOSSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (BOOL)isIphone5
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (CGFloat)phoneHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)viewHeight
{
    return [UIScreen mainScreen].bounds.size.height-20;
}

+ (CGFloat)navBarHeightWithController:(UIViewController *)target {
    CGFloat h = 0.f;
    if (target == nil
        || target.navigationController == nil
        || target.navigationController.navigationBar == nil)
        return h;
    
    h = target.navigationController.navigationBar.frame.size.height;
    return h;
}

+ (CGRect)screenFrame
{
    CGFloat screenHeight = [TSPUtils phoneHeight];
    return CGRectMake(0, 0, 320, screenHeight);
}

+ (CGRect)viewFrame
{
    CGFloat screenHeight = [TSPUtils phoneHeight];
    CGFloat viewHeight   = screenHeight - 20.0f;
    return CGRectMake(0, 0.0f, 320.0f, viewHeight);
}


+ (NSString *)intFormatter:(int)longNumber{
    NSNumber *number = [NSNumber numberWithInt:longNumber];
    return [self numberFormatter:number];
}

+ (NSString *)doubleFormatter:(double)longNumber{
    NSNumber *number = [NSNumber numberWithDouble:longNumber];
    return [self numberFormatter:number];
}

+ (NSString *)longLongFormatter:(long long)longNumber{
    NSNumber *number = [NSNumber numberWithLongLong:longNumber];
    return [self numberFormatter:number];
}
+ (NSString *)floatFormatter:(float)floatNumber{
    NSNumber *number = [NSNumber numberWithFloat:floatNumber];
    return [self numberFormatter:number];
}

+ (NSString *)numberFormatter:(NSNumber *)number{
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setGroupingSize:3];
    [frmtr setAllowsFloats:YES];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
    [frmtr setMaximumFractionDigits:2];
    NSString *commaString = [frmtr stringFromNumber:number];
    [frmtr release];
    return commaString;
}

+ (BOOL)networkState
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability,&flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags)
    {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

/**
 alertview
 */

+ (void)showAlertView:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

+ (void)showMessageBox:(NSString *)message
{
    if ([theAppWindow viewWithTag:99999]) {
        [[theAppWindow viewWithTag:99999] removeFromSuperview];
    }
    [self initAlertLabel:message hidden:YES];
}

+ (void)initAlertLabel:(NSString *)message hidden:(BOOL)hidden
{
    UIFont *font = [UIFont systemFontOfSize:14];
    //CGFloat width = [message widthWithFont:font];
    CGFloat height = [message heightForLineWidth:300 font:font];
    if (height > 30) {
        height+= 10;
    }else {
        height = 30;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 300, height)];
    label.backgroundColor = [UIColor grayColor];
    label.alpha = 1.0;
    label.text = message;
    label.font = font;
    label.layer.cornerRadius = 5.0f;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = [[UIColor whiteColor] CGColor];
    label.layer.borderWidth = 1.0f;
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.tag = 99999;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    //label.center = theAppWindow.center;
    [theAppWindow addSubview:label];
    if (hidden) {
        [UIView animateWithDuration:4.5
                         animations:^{
                             if (label) {
                                 label.alpha = 0.2;
                             }
                         }
                         completion:^(BOOL finish){
                             if (label) {
                                 [label removeFromSuperview];
                             }
                         }];
    }else {
        ESAFERelease(label);
    }
}

+ (void)dismissMessageBox
{
    if ([theAppWindow viewWithTag:99999]) {
        [[theAppWindow viewWithTag:99999] removeFromSuperview];
    }
}

+ (void)animateMessage:(NSString *)message
{
    if ([theAppWindow viewWithTag:99999]) {
        [[theAppWindow viewWithTag:99999] removeFromSuperview];
    }
    [self initAlertLabel:message hidden:NO];
    [self performSelector:@selector(dismissMessageBox) withObject:nil afterDelay:2];
}

/**
 MBHud
 */

//+ (void)showMBHUD:(NSString *)message delegate:(id)delegate
//{
//    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:theAppWindow animated:YES];
//    hud.mode            = MBProgressHUDModeCustomView;
//    hud.tag             = HUDTAG;
//    hud.delegate        = delegate;
//    hud.labelText       = message;
//}

//+ (void)removeMBHUD
//{
//    for (UIView * v in theAppWindow.subviews) {
//        if (v.tag == HUDTAG) {
//            [v removeFromSuperview];
//        }
//    }
//}


+ (void)store2File:(NSData *)data fileName:(NSString *)name {
    NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString * documentDirectory = [documentPaths objectAtIndex:0];
    NSString * fileName = [documentDirectory stringByAppendingPathComponent:name];
    [data writeToFile:fileName atomically:YES];
}

+ (NSData *)fileFromStorageByFileName:(NSString *)name {
    NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString * documentDirectory = [documentPaths objectAtIndex:0];
    NSString * fileName = [documentDirectory stringByAppendingPathComponent:name];
    return [NSData dataWithContentsOfFile:fileName];
}

@end


#pragma mark - StringUtils

@implementation StringUtils
+ (BOOL)isEmptyOrNull:(NSString *)string
{
    BOOL isEmptyOrNull = YES;
    if (![string isEqual:[NSNull null]] && string != nil && string.length != 0) {
        NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
        NSArray *parts = [string componentsSeparatedByString:@" "];
        NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
        string = [filteredArray componentsJoinedByString:@""];
        if (string.length > 0) {
            isEmptyOrNull = NO;
        }
    }
    return isEmptyOrNull;
}
@end

@implementation UIImage (GD10000_Utilities)

+ (UIImage *)imageUtilName:(NSString *)name
{
    NSString *path = nil;
    if ( [name isAbsolutePath] ) {
        path = name;
    } else {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    }
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)imageJpgName:(NSString *)name
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
}

- (UIImage *)stretchableImage
{
    CGFloat hSpacing = floor((self.size.width+1.0)/2.0)-1.0;
    hSpacing = MAX(0.0, hSpacing);
    CGFloat vSpacing = floor((self.size.height+1.0)/2.0)-1.0;
    vSpacing = MAX(0.0, vSpacing);
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(vSpacing, hSpacing, vSpacing, hSpacing);
    return [self stretchableImageWithCapInsets:edgeInsets];
}

- (UIImage *)stretchableImageWithCenterSize:(CGSize)centerSize
{
    CGFloat hSpacing = floor((self.size.width - centerSize.width)/2.0);
    CGFloat vSpacing = floor((self.size.height - centerSize.height)/2.0);
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(vSpacing, hSpacing, vSpacing, hSpacing);
    return [self stretchableImageWithCapInsets:edgeInsets];
}

- (UIImage *)stretchableImageWithCapInsets:(UIEdgeInsets)capInsets
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(floor(capInsets.top),
                                               floor(capInsets.left),
                                               floor(capInsets.bottom),
                                               floor(capInsets.right));
    
    CGFloat systemVersion = [[[[UIDevice class] currentDevice] systemVersion] floatValue];
    if ( systemVersion < 5.0 ) {
        return [self stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top];
    }
    //NSLog(@"%f,%f,%f,%f",edgeInsets.top,edgeInsets.left,edgeInsets.bottom,edgeInsets.right);
    return [self resizableImageWithCapInsets:edgeInsets];
}

- (UIImage *)scaleImageWithScale:(float)scaleSize {
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
                                
    return scaledImage;                                
}


- (long)fileSize
{
    NSLog(@"newImage.size = %@",NSStringFromCGSize(self.size));
    int bpc = CGImageGetBitsPerComponent(self.CGImage);
    int bpp = CGImageGetBitsPerPixel(self.CGImage);
    int  perMBBytes = 1024*1024;
    size_t bytes_per_pixel = bpp / bpc;
    long lPixelsPerMB  = perMBBytes/bytes_per_pixel;
    long totalPixel = CGImageGetWidth(self.CGImage)*CGImageGetHeight(self.CGImage);
    long totalFileMB = totalPixel/lPixelsPerMB;
    return totalFileMB;
}

@end

#pragma mark - UIButton (GD10000_Utilities)

@implementation UIButton (GD10000_Utilities)

static char const * const sectionKey = "kUIButtonSectionKey";
static char const * const rowKey = "kUIButtonRowKey";

@dynamic section;
@dynamic row;

- (int)row{
    NSNumber *row = objc_getAssociatedObject(self, rowKey);
    return [row intValue];
}
- (void)setRow:(NSInteger)row
{
    objc_setAssociatedObject(self, rowKey, [NSNumber numberWithInt:row], OBJC_ASSOCIATION_ASSIGN);
}

- (int)section{
    NSNumber *section = objc_getAssociatedObject(self, sectionKey);
    return [section intValue];
}

- (void)setSection:(int)section
{
    objc_setAssociatedObject(self, sectionKey, [NSNumber numberWithInt:section], OBJC_ASSOCIATION_ASSIGN);
}

- (void)setNormalTitle:(NSString *)normalTitle
{
    [self setTitle:normalTitle forState:UIControlStateNormal];
}

- (void)setHighlightedTitle:(NSString *)highlightedTitle
{
    [self setTitle:highlightedTitle forState:UIControlStateHighlighted];
}

- (void)setDisabledTitle:(NSString *)disabledTitle
{
    [self setTitle:disabledTitle forState:UIControlStateDisabled];
}

- (void)setSelectedTitle:(NSString *)selectedTitle
{
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}

- (void)setNormalImage:(UIImage *)normalImage
{
    [self setImage:normalImage forState:UIControlStateNormal];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    [self setImage:selectedImage forState:UIControlStateSelected];
}

- (void)setNormalBgImage:(UIImage *)normalBackgroundImage
{
    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
}

- (void)setHighlightedBgImage:(UIImage *)highlightedBackgroundImage
{
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

- (void)setDisabledBgImage:(UIImage *)disabledBackgroundImage
{
    [self setBackgroundImage:disabledBackgroundImage forState:UIControlStateDisabled];
}

- (void)setSelectedBgImage:(UIImage *)selectedBackgroundImage
{
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
}

- (void)setDisabledTitleColor:(UIColor *)normalTitleColor
{
    [self setTitleColor:normalTitleColor forState:UIControlStateDisabled];
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor
{
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

- (UIColor *)normalTitleShadowColor
{
    return [self titleShadowColorForState:UIControlStateNormal];
}
- (void)setNormalTitleShadowColor:(UIColor *)normalTitleShadowColor
{
    [self setTitleShadowColor:normalTitleShadowColor forState:UIControlStateNormal];
}

- (UIColor *)highlightedTitleShadowColor
{
    return [self titleShadowColorForState:UIControlStateHighlighted];
}
- (void)setHighlightedTitleShadowColor:(UIColor *)highlightedTitleShadowColor
{
    [self setTitleShadowColor:highlightedTitleShadowColor forState:UIControlStateHighlighted];
}

- (UIColor *)disabledTitleShadowColor
{
    return [self titleShadowColorForState:UIControlStateDisabled];
}
- (void)setDisabledTitleShadowColor:(UIColor *)disabledTitleShadowColor
{
    [self setTitleShadowColor:disabledTitleShadowColor forState:UIControlStateDisabled];
}

- (UIColor *)selectedTitleShadowColor
{
    return [self titleShadowColorForState:UIControlStateSelected];
}
- (void)setSelectedTitleShadowColor:(UIColor *)selectedTitleShadowColor
{
    [self setTitleShadowColor:selectedTitleShadowColor forState:UIControlStateSelected];
}

- (void)setControlStateTitleColor:(UIColor *)stateTitleColor
{
    [self setNormalTitleColor:stateTitleColor];
    [self setHighlightedTitleColor:stateTitleColor];
    [self setSelectedTitleColor:stateTitleColor];
}

- (void)touchUpInsideTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchDownTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

- (void)touchUpOutsideTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpOutside];
}

@end

#pragma mark - UIImageView (GD10000_Utilities)

@implementation UIImageView (GD10000_Utilities)

- (void)setImageName:(NSString *)imageName
{
    NSString *path = nil;
    if ( [imageName isAbsolutePath] ) {
        path = imageName;
    } else {
        path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    }
    
    UIImage *newImage = [[UIImage alloc] initWithContentsOfFile:path];
    self.image = newImage;
    [newImage release];
}

@end

#pragma mark - NSString (GD10000_Utilities)

@implementation NSString (GD10000_Utilities)

- (CGFloat)widthWithFont:(UIFont *)font
{
    CGSize size = [self sizeWithFont:font];
    CGFloat width = size.width;
    return width;
}

- (CGFloat)heightWithFont:(UIFont *)font
{
    CGSize size = [self sizeWithFont:font];
    CGFloat height = size.height;
    return height;
}

- (CGFloat)heightForLineWidth:(CGFloat)width font:(UIFont *)font
{
    CGSize size = [self sizeWithFont:font
                            constrainedToSize:CGSizeMake(width, 30000000.0f)
                                lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

- (BOOL)isEmptyOrNull
{
    BOOL isEmptyOrNull = YES;
    if (![self isEqual:[NSNull null]] && self != nil && self.length != 0) {
        NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
        NSArray *parts = [self componentsSeparatedByString:@" "];
        NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
        self = [filteredArray componentsJoinedByString:@""];
        if (self.length > 0) {
            isEmptyOrNull = NO;
        }
    }
    return isEmptyOrNull;
}

- (NSString *)subStringAtLoc:(NSInteger)loc leng:(NSInteger)len
{
    return [self substringWithRange:NSMakeRange(loc, len)];
}

- (NSUInteger)countOccurrencesOfSubstring:(NSString *)substring
{
    /*
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:substring options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    return numberOfMatches;
    //*/
    NSInteger result = -1;
    NSRange range = NSMakeRange(0, 0);
    do {
        ++result;
        range = NSMakeRange(range.location + range.length,
                            self.length - (range.location + range.length));
        range = [self rangeOfString:substring options:0 range:range];
    } while (range.location != NSNotFound);
    return result;
}

- (NSArray *)arrayOccurrencesOfSubstring:(NSString *)substring
{
    NSMutableArray *ranges = [NSMutableArray arrayWithCapacity:0];
    NSInteger result = -1;
    NSRange range = NSMakeRange(0, 0);
    do {
        ++result;
        range = NSMakeRange(range.location + range.length,
                            self.length - (range.location + range.length));
        range = [self rangeOfString:substring options:0 range:range];
        if (range.location != NSNotFound) {
            [ranges addObject:NSStringFromRange(range)];
        }
    } while (range.location != NSNotFound);
    return ranges;
}

@end

#pragma mark - UIView (GD10000_Utilities)

@implementation UIView (GD10000_Utilities)

- (void)addSwipeWithTarget:(id)target action:(SEL)action
{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    recognizer.delegate = target;
	[recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:recognizer];
    [recognizer release];
}

@end

#pragma mark - NSDictionary (GD10000_Utilities)

@implementation NSDictionary (GD10000_Utilities)

- (NSData *)GD10000_JSONData
{
    return [[self JSONString] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

@end

#pragma mark - NSDate (GD10000_Utilities)

@implementation NSDate (GD10000_Utilities)

- (NSString *)updateDate
{
    NSString *string = [NSString stringWithFormat:@"%d/%02d/%02d",[self getYear],[self getMonth],[self getDay]];
    return string;
}

- (NSString *)formatCnDate
{
    NSString *string = [NSString stringWithFormat:@"%d年%02d月%02d日",[self getYear],[self getMonth],[self getDay]];
    return string;
}

- (NSString *)formatSampleDate
{
    NSString *string = [NSString stringWithFormat:@"%d-%02d-%02d",[self getYear],[self getMonth],[self getDay]];
    return string;
}

- (NSString *)formatCnMDate
{
    NSString *string = [NSString stringWithFormat:@"%d年%02d月",[self getYear],[self getMonth]];
    return string;
}

- (NSString *)getFormatYearMonth
{
    NSString *string = [NSString stringWithFormat:@"%d%02d",[self getYear],[self getMonth]];
    return string;
}

//获取年月日如:19871127.
- (NSString *)getFormatYearMonthDay
{
    NSString *string = [NSString stringWithFormat:@"%d%02d%02d",[self getYear],[self getMonth],[self getDay]];
    return string;
}
//返回当前月一共有几周(可能为4,5,6)
- (int)getWeekNumOfMonth
{
    return [[self endOfMonth] getWeekOfYear] - [[self beginningOfMonth] getWeekOfYear] + 1;
}
//该日期是该年的第几周
- (int)getWeekOfYear
{
    int i;
    int year = [self getYear];
    NSDate *date = [self endOfWeek];
    for (i = 1;[[date dateAfterDay:-7 * i] getYear] == year;i++)
    {
    }
    return i;
}

+ (NSDate *)beginningOfToday
{
    return [[NSDate date] beginningOfDay];
}

+ (NSDate *)dateAfterBeginningOfToday:(int)day
{
    return [[NSDate date] dateAfterBeginningOfDay:day];
}

- (NSDate *)dateAfterBeginningOfDay:(int)day
{
    return [[self beginningOfDay] dateAfterDay:day];
}

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    [componentsToAdd release];
    
    return dateAfterDay;
}
//month个月后的日期
- (NSDate *)dateAfterMonth:(int)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    [componentsToAdd release];
    return dateAfterMonth;
}

//获取日
- (NSUInteger)getDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
    return [dayComponents day];
}
//获取月
- (NSUInteger)getMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
    return [dayComponents month];
}
//获取年
- (NSUInteger)getYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
    return [dayComponents year];
}
//获取小时
- (int )getHour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger hour = [components hour];
    return (int)hour;
}
//获取分钟
- (int)getMinute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger minute = [components minute];
    return (int)minute;
}

- (int )getHour:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [components hour];
    return (int)hour;
}

- (int)getMinute:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger minute = [components minute];
    return (int)minute;
}

//在当前日期前几天
- (NSUInteger)daysAgo {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components day];
}

//午夜时间距今几天
- (NSUInteger)daysAgoAgainstMidnight {
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
    [mdf release];
    
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
    return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
    NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
    NSString *text = nil;
    switch (daysAgo) {
        case 0:
            text = @"Today";
            break;
        case 1:
            text = @"Yesterday";
            break;
        default:
            text = [NSString stringWithFormat:@"%d days ago", daysAgo];
    }
    return text;
}
//返回一周的第几天(周末为第一天)
- (NSUInteger)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
    return [weekdayComponents weekday];
}
//NSString to NSDate
+ (NSDate *)dateFromString:(NSString *)string {
    return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    [inputFormatter release];
    return date;
}



+ (NSDate *)dateFromUTCString:(NSString *)string
{
    return [NSDate dateFromUTCString:string withFormat:[NSDate dateFormatString]];
}

+ (NSDate *)dateForYm:(NSString *)string
{
    return [NSDate dateFromUTCString:string withFormat:[NSDate yearMonth]];
}

+ (NSDate *)dateForYmd:(NSString *)string
{
    return [NSDate dateFromUTCString:string withFormat:[NSDate ymdFormatString]];
}

+ (NSDate *)dateFromUTCString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    ////设置时区
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}

+ (NSString *)stringFromUTCDate:(NSDate *)date
{
    return [NSDate stringFromUTCDate:date withFormat:[NSDate dateFormatString]];
}

+ (NSString *)stringFromUTCDate1:(NSDate *)date
{
    return [NSDate stringFromUTCDate:date withFormat:[NSDate dateFormatString1]];
}

+ (NSString *)stringFromUTCDate2:(NSDate *)date
{
    return [NSDate stringFromUTCDate:date withFormat:[NSDate dateFormatString2]];
}

+ (NSString *)stringFromCNDate:(NSDate *)date
{
    return [NSDate stringFromDate:date withFormat:[NSDate timeFormatCNString]];
}

+ (NSString *)stringFromUTCDate:(NSDate *)date withFormat:(NSString *)format
{
	return [date stringWithUTCFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                     fromDate:today];
    
    NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    NSString *displayString = nil;
    
    // comparing against midnight
    if ([date compare:midnight] == NSOrderedDescending) {
        if (prefixed) {
            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
        }
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
        [componentsToSubtract release];
        if ([date compare:lastweek] == NSOrderedDescending) {
            [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
        } else {
            // check if same calendar year
            NSInteger thisYear = [offsetComponents year];
            
            NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                           fromDate:date];
            NSInteger thatYear = [dateComponents year];
            if (thatYear >= thisYear) {
                [displayFormatter setDateFormat:@"MMM d"];
            } else {
                [displayFormatter setDateFormat:@"MMM d, yyyy"];
            }
        }
        if (prefixed) {
            NSString *dateFormat = [displayFormatter dateFormat];
            NSString *prefix = @"'on' ";
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
        }
    }
    displayString = [displayFormatter stringFromDate:date];
    [displayFormatter release];
    return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithUTCFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]]; //setLocale 方法将其转为中文的日期表达
    ////设置时区
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
	dateFormatter.dateFormat = format;
	NSString *tempstr = [dateFormatter stringFromDate:self];
    return tempstr;
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    [outputFormatter release];
    return timestamp_str;
}

- (NSString *)string {
    return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:dateStyle];
    [outputFormatter setTimeStyle:timeStyle];
    NSString *outputString = [outputFormatter stringFromDate:self];
    [outputFormatter release];
    return outputString;
}
//返回周日的的开始时间
- (NSDate *)beginningOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *beginningOfWeek = nil;
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
                           interval:NULL forDate:self];
    if (ok) {
        return beginningOfWeek;
    }
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    beginningOfWeek = nil;
    beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    [componentsToSubtract release];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:beginningOfWeek];
    return [calendar dateFromComponents:components];
}
//返回当前天的年月日.
- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}
//返回该月的第一天
- (NSDate *)beginningOfMonth
{
    return [self dateAfterDay:-[self getDay] + 1];
}
//该月的最后一天
- (NSDate *)endOfMonth
{
    return [[[self beginningOfMonth] dateAfterMonth:1] dateAfterDay:-1];
}
//返回当前周的周末
- (NSDate *)endOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    [componentsToAdd release];
    
    return endOfWeek;
}

+ (NSString *)dateFormatString {
    return @"yyyy-MM-dd";
}

+ (NSString *)dateFormatString1 {
    return @"yyyy/MM/dd";
}
+ (NSString *)dateFormatString2 {
    return @"EEEE aa HH:mm";
}

+ (NSString *)timeFormatCNString {
    return @"yyyy年MM月dd日";
}

+ (NSString *)timeFormatString {
    return @"HH:mm:ss";
}

+ (NSString *)yearMonth {
    return @"yyyyMM";
}

+ (NSString *)timestampFormatString {
    return @"yyyy-MM-dd HH:mm:ss";
}
+ (NSString *)ymdFormatString {
    return @"yyyyMMdd";
}
+ (NSString *)dbFormatString {
    return [NSDate timestampFormatString];
}


@end

#include "sys/types.h"
#include "sys/sysctl.h"

@implementation UIDevice (UIDeviceAdditions)

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (double)currentMemoryUsage {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
    if(kernReturn == KERN_SUCCESS)
        return vmStats.wire_count/1024.0;
    else return 0;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSString*)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

- (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 GSM";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 CDMA";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

@end


@implementation UIColor (UIColorHex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    NSLog(@"%f,%f,%f",(float)((hexValue & 0xFF0000) >> 16),
                      (float)((hexValue & 0xFF00) >> 8),
                      (float)(hexValue & 0xFF));
    
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}
@end
