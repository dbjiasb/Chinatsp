//
//  MyUtil.m
//  HotelManager
//
//  Created by Dragon Huang on 13-4-26.
//  Copyright (c) 2013年 baiwei.Yuan Wen. All rights reserved.
//

#import "MyUtil.h"
#import <objc/runtime.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <QuartzCore/QuartzCore.h>

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

@implementation UIImage (HL_Utilities)

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

@end

#pragma mark - UIButton (DH_Utilities)

@implementation UIButton (DH_Utilities)

static char const * const sectionKey = "kUIButtonSectionKey";

@dynamic section;

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

#pragma mark - UIImageView (DH_Utilities)

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

#pragma mark - NSString (DH_Utilities)

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

@end

#pragma mark - UIView (DH_Utilities)

@implementation UIView (HL_Utilities)

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

#pragma mark - UINavigationController

@implementation UINavigationController (HL_Utilities)
- (void)setBgImageName:(NSString *)name
{
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:name] forBarMetrics:UIBarMetricsDefault];
        
    }
}
@end

@implementation UINavigationItem (HL_Utilities)

- (void)setCustomTitle:(NSString *)name
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    title.textColor = RGBCOLOR(80, 103, 116);
    title.text = name;
    title.textAlignment = UITextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    title.backgroundColor = [UIColor clearColor];
    self.titleView = title;

}

@end

@implementation UINavigationBar (HL_Utilities)

- (void)drawRect:(CGRect)rect {
    
    [[self barBackground] drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height )];
	
	
}
- (UIImage *)barBackground
{
//    if (self.frame.size.height > self.frame.size.width) {
    return [UIImage imageNamed:@"bg_navi"];
//    }
//    else
//    {
//        return [UIImage imageNamed:@"navibar_bg_lands-568h"];
//    }
    
    
}

- (void)didMoveToSuperview
{
    //iOS5 only
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        //UIBarStyleDefault
        [self setBackgroundImage:[self barBackground] forBarMetrics:UIBarMetricsDefault];
    }
    [self setNeedsDisplay];
}

@end

@implementation UIViewController (Utilities)

- (void)setBackBarBtnImage
{
    UIBarButtonItem *backBarButton = [[[UIBarButtonItem alloc] init] autorelease];
    [backBarButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 15, 4)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [backBarButton setBackButtonBackgroundImage:[[UIImage imageUtilName:@"emark_backbtn_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 15, 4)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backBarButton;
}
@end

#pragma mark - MyUtil

@implementation MyUtil

//判断本地网络是否打开
+(BOOL)checkNetIsConnect
{
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"dipinkrishna.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    } else {
        return TRUE;
    }
}

+(float)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}
+(float)screenHeight
{
    return [[UIScreen mainScreen] bounds].size.height - 20;
    
}
+ (float)viewHeight
{
    return [self screenHeight];
}

+(NSString *)GetNowTime{
    
    NSDateFormatter *tempDate = [[[NSDateFormatter alloc]init] autorelease];
    [tempDate setLocale:[NSLocale currentLocale]];
    
    [tempDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//24小时制
    
    NSDate* now = [NSDate date];
    NSString *tempDatestring = [tempDate stringFromDate:now];
    
    
    return tempDatestring;
    //    //NSLog(@"time.....%@",now);
}


+ (BOOL)isIphone5
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO);
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
    [label release];
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
    }
}



@end
