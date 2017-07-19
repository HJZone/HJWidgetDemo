//
//  HJImageTitleButton.h
//  HJWidgetDemo
//
//  Created by 浩杰 on 2017/7/18.
//  Copyright © 2017年 haojie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HJImageButtonType) {
    HJImageButtonTypeForLeftAndRight = 10,  //左右
    HJImageButtonTypeForUpAndDown = 11      //上下
};


@interface HJImageTitleButton : UIButton

/** 图片背景颜色 **/
@property (nonatomic , strong) UIColor *iconBackgroundColor;

/** 图片背景是否剪切成圆角 **/
@property (nonatomic , assign) BOOL iconIsRound;

/** 图标的缩放，默认为1.f **/
@property (nonatomic , assign) CGFloat iconScale;


/**
 自定义的初始化方式，其他类型的初始化无效

 @param imageName imageName
 @param title title
 @param font title font
 @param type HJImageButtonType
 @return 实例对象
 */
- (instancetype)initWithImageName:(NSString*)imageName
                        withTitle:(NSString*)title withTitleFont:(UIFont *)font withType:(HJImageButtonType)type;

/**
 设置Icon的缩放比例（0.0 - 1.0），参考值是宽和高德最小值，比如size（60，80），那么这个参考值就是60，如果需要图片的尺寸为40*40，那么此时scale为40/60,也就是0.66

 @param scale scale
 */
- (void)setIconScaleWithScale:(CGFloat)scale;

/**
 设置Icon到标题的距离

 @param spaceScale scale
 */
- (void)setIconToTitleSpaceScale:(CGFloat)spaceScale;


/**
 设置图片、标题

 @param image image
 @param title title
 @param state state
 */
- (void)setImage:(UIImage *)image title:(NSString *)title forState:(UIControlState)state;




@end
