//
//  HJImageTitleButton.m
//  HJWidgetDemo
//
//  Created by 浩杰 on 2017/7/18.
//  Copyright © 2017年 haojie. All rights reserved.
//

#import "HJImageTitleButton.h"

static  NSInteger _type;
static NSString *titleString;
static UIImageView *btnImageView;
static UIFont *myFont;
static  UIView*iconBackView;

@implementation HJImageTitleButton

- (instancetype)initWithImageName:(NSString*)imageName
                        withTitle:(NSString*)title withTitleFont:(UIFont *)font withType:(HJImageButtonType)type
{
    _type = type;
    titleString = title;
    myFont = font;
    HJImageTitleButton* button =
    [HJImageTitleButton buttonWithType:UIButtonTypeCustom];
    
    [button.titleLabel setFont:font];
    [button setTitle:title forState:UIControlStateNormal];
    if (imageName.length != 0) {
        
        btnImageView = [[UIImageView alloc]
                        init];
        iconBackView = [[UIView alloc] init];
        [button addSubview:iconBackView];
        iconBackView.userInteractionEnabled = NO;
        
        btnImageView.image = [UIImage imageNamed:imageName];
        [button addSubview:btnImageView];
        
        
    }
    
    return button;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.size.width < 1) {
        return;
    }
    
    float num = frame.size.width > frame.size.height ? frame.size.height : frame.size.width;
    if (_type == HJImageButtonTypeForLeftAndRight) {
        
        float stringWidth = [self getStringWidthWithString:titleString height:frame.size.height];
        
        float stringHeight = [self getStringHeightWithString:titleString width:100];
        
        btnImageView.frame = CGRectMake(frame.size.width / 2 - (stringWidth + frame.size.height - (frame.size.height - stringHeight)) / 2, (frame.size.height - stringHeight) / 2, stringHeight, stringHeight);
        
        iconBackView.frame = btnImageView.frame;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, frame.size.width / 2 - (stringWidth + frame.size.height - (frame.size.height - stringHeight)) / 2 + stringHeight, 0, 0)];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    else if (_type == HJImageButtonTypeForUpAndDown)
    {
        num = frame.size.width;
        btnImageView.frame = CGRectMake(num / 4.0, num / 8.0, num / 2.0, num / 2.0);
        iconBackView.frame = btnImageView.frame;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(frame.size.height * 0.75, 0, 0, 0)];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    
    
}

- (void)setIconScaleWithScale:(CGFloat)scale
{
    
    CGRect frame = self.frame;
    float num = frame.size.width > frame.size.height ? frame.size.height : frame.size.width;
    
    if (scale >1 || scale < 0.01) {
        return;
    }
    
    if (_type == HJImageButtonTypeForUpAndDown)
    {
        num = frame.size.width;
        float width = num * scale;
        btnImageView.frame = CGRectMake(num * (1 - scale) / 2.0, (frame.size.height * 0.75 - width) / 2, width, width);
        iconBackView.frame = btnImageView.frame;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(frame.size.height * 0.75, 0, 0, 0)];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    else
    {
        num = frame.size.width;
        float width = num * scale;
        btnImageView.frame = CGRectMake(num * (1 - scale) / 2.0, (frame.size.height * 0.75 - width) / 2, width, width);
        iconBackView.frame = btnImageView.frame;
    }
}

- (void)setIconToTitleSpaceScale:(CGFloat)spaceScale
{
    if (spaceScale < 0 || spaceScale > 1) {
        return;
    }
    
    if (_type == HJImageButtonTypeForLeftAndRight) {
        
        
        
        float stringWidth = [self getStringWidthWithString:titleString height:self.frame.size.height] + self.frame.size.width * spaceScale;
        
        float stringHeight = [self getStringHeightWithString:titleString width:self.frame.size.width];
        btnImageView.frame = CGRectMake(self.frame.size.width / 2 - (stringWidth + self.frame.size.height - (self.frame.size.height - stringHeight)) / 2, (self.frame.size.height - stringHeight) / 2, stringHeight, stringHeight);
        iconBackView.frame = btnImageView.frame;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width / 2 - (stringWidth + self.frame.size.height - (self.frame.size.height - stringHeight)) / 2 + stringHeight + self.frame.size.width * spaceScale, 0, 0)];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    else if (_type == HJImageButtonTypeForUpAndDown)
    {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.frame.size.height * spaceScale, 0, 0, 0)];
    }
}

- (void)setImage:(UIImage *)image title:(NSString *)title forState:(UIControlState)state
{
    btnImageView.image = image;
    [self setTitle:title forState:state];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
}

- (CGFloat)getStringWidthWithString:(NSString*)string height:(CGFloat)height
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : myFont } context:nil];
    
    return rect.size.width + 2;
}

- (CGFloat)getStringHeightWithString:(NSString*)string width:(CGFloat)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : myFont } context:nil];
    
    return rect.size.height + 2;
}

- (void)setIconBackgroundColor:(UIColor *)iconBackgroundColor
{
    iconBackView.backgroundColor = iconBackgroundColor;
}

- (void)setIconIsRound:(BOOL)iconIsRound
{
    if (iconIsRound == YES) {
        iconBackView.layer.cornerRadius = iconBackView.frame.size.width/2;
        iconBackView.layer.masksToBounds = YES;
    }
    _iconIsRound = iconIsRound;
    
}

- (void)setIconScale:(CGFloat)iconScale
{
    _iconScale = iconScale;
    
    btnImageView.transform = CGAffineTransformScale(btnImageView.transform, iconScale, iconScale);
}


@end
