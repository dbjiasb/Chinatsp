//
//  MyUtil.h
//  HotelManager
//
//  Created by Dragon Huang on 13-4-26.
//  Copyright (c) 2013年 baiwei.Yuan Wen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONKit.h"
#import "EMarketing_BarButtonItemUtil.h"

#define ISNULL(__pointer)         (__pointer == nil || [[NSNull null] isEqual:__pointer])

#define SAVE_RELEASE(__pointer)			{if (__pointer) {						   \
[__pointer release]; __pointer = nil; \
}										   \
}
#define RGBCOLOR(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define theAppWindow	            [[UIApplication sharedApplication] keyWindow]

#pragma mark - string Utils
@interface StringUtils : NSObject
+ (BOOL)isEmptyOrNull:(NSString *)string;
@end


#pragma mark - UIImage (DH_Utilities)

@interface UIImage (DH_Utilities)
+ (UIImage *)imageUtilName:(NSString *)name;

/*
 * Stretchable image
 */
- (UIImage *)stretchableImage;
- (UIImage *)stretchableImageWithCenterSize:(CGSize)centerSize;
- (UIImage *)stretchableImageWithCapInsets:(UIEdgeInsets)capInsets;
- (UIImage *)scaleImageWithScale:(float)scaleSize;
@end

#pragma mark - UIButton (DH_Utilities)

@interface UIButton (DH_Utilities)

@property (nonatomic, assign) NSInteger section;

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

#pragma mark - UIImageView (DH_Utilities)

@interface UIImageView (DH_Utilities)

- (void)setImageName:(NSString *)imageName;

@end


#pragma mark - NSString (DH_Utilities)

@interface NSString (DH_Utilities)

- (CGFloat)widthWithFont:(UIFont *)font;
- (CGFloat)heightWithFont:(UIFont *)font;

- (CGFloat)heightForLineWidth:(CGFloat)width font:(UIFont *)font;

- (BOOL)isEmptyOrNull;

- (NSString *)subStringAtLoc:(NSInteger)loc leng:(NSInteger)len;

@end

#pragma mark - UIView (DH_Utilities)

@interface UIView (GD10000_Utilities)

- (void)addSwipeWithTarget:(id)target action:(SEL)action;

@end

@interface  UINavigationBar (HL_Utilities)

@end

#pragma mark - UINavigationController

@interface UINavigationController (HL_Utilities)
- (void)setBgImageName:(NSString *)name;
@end

@interface UINavigationItem (HL_Utilities)
- (void)setCustomTitle:(NSString *)name;
@end


#pragma mark - UIViewController (Utilities)

@interface UIViewController (Utilities)

- (void)setBackBarBtnImage;

@end

@interface MyUtil : NSObject

+(BOOL)checkNetIsConnect;
+(float)screenWidth;
+(float)screenHeight;
//获取当前时间
+(NSString *)GetNowTime;
+ (BOOL)isIphone5;
+ (void)showMessageBox:(NSString *)message;
+ (float)viewHeight;
@end
