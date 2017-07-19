//
//  TodayViewController.m
//  HJSecondWidget
//
//  Created by 浩杰 on 2017/7/18.
//  Copyright © 2017年 haojie. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "HJImageTitleButton.h"

#define SC_WIDTH    [UIScreen mainScreen].bounds.size.width//屏幕宽度
#define SC_HEIGHT   [UIScreen mainScreen].bounds.size.height//屏幕高度
#define RGB_COLOR(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


@interface TodayViewController () <NCWidgetProviding>
/** <#注释#> **/
@property (nonatomic , strong) UIView *topView;

/** <#注释#> **/
@property (nonatomic , strong) UILabel *titleLabel;

/** <#注释#> **/
@property (nonatomic , strong) UIView *bottomView;


@end

@implementation TodayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
    
    /*
     设置Widget的样式，这是iOS 10的新特性，也就是所谓的“折叠”、“打开”模式，
     NCWidgetDisplayModeCompact, // Fixed height
     NCWidgetDisplayModeExpanded, // Variable height
     */
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    [self setUpUI];
}

- (void)setUpUI
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SC_WIDTH, 95)];
    [self.view addSubview:_topView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(90, 10, SC_WIDTH - 90, 75)];
    backView.backgroundColor = RGB_COLOR(219, 235, 249);
    [_topView addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"000000"]];
    imageView.frame = CGRectMake(15, 10, 75, 75);
    [_topView addSubview:imageView];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, SC_WIDTH - 100 - 25, 25)];
    nameLabel.text = @"「盛夏时光，听一场被雨打...」";
    [_topView addSubview:nameLabel];
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, SC_WIDTH - 100 - 35, 20)];
    authorLabel.text = @"by 蝶影丛虫";
    authorLabel.font = [UIFont systemFontOfSize:12];
    authorLabel.textColor = RGB_COLOR(97, 93, 92);
    [_topView addSubview:authorLabel];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, SC_WIDTH - 30, 30)];
    _titleLabel.text = @"听一场被雨打湿的电影";
    [self.view addSubview:_titleLabel];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, SC_WIDTH, 105)];
    [self.view addSubview:_bottomView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, SC_WIDTH - 30, 0.5)];
    lineView.backgroundColor = RGB_COLOR(187, 177, 168);
    [_bottomView addSubview:lineView];
    
    NSArray *_imageArray = @[@"icon_0",@"icon_1",@"icon_2",@"icon_3"];
    NSArray *_titleArray = @[@"陪你工作",@"私人FM",@"下载的音乐",@"听歌识曲"];
    for (int a = 0; a < _imageArray.count; a ++) {
        
        CGFloat itemHeight = 70.f;
        CGFloat width = SC_WIDTH * 0.95;
        
        HJImageTitleButton *btn = [[HJImageTitleButton alloc] initWithImageName:_imageArray[a] withTitle:_titleArray[a] withTitleFont:[UIFont systemFontOfSize:12] withType:HJImageButtonTypeForUpAndDown];
        btn.frame = CGRectMake((width - itemHeight * 4)/4 * (a % 4) + itemHeight * (a % 4) + (width - itemHeight * 4)/8, 15, itemHeight, itemHeight);
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btn setIconScaleWithScale:0.6];
        [btn setIconToTitleSpaceScale:0.7];
        [btn setTitleColor:RGB_COLOR(110, 120, 131) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn.tag = 120 + a;
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.iconScale = 1.3;
        btn.iconBackgroundColor = RGB_COLOR(219, 235, 249);
        btn.iconIsRound = YES;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
    }
    
}

- (void)buttonClick:(HJImageTitleButton *)sender
{
    NSString *urlString = [NSString stringWithFormat:@"hjWidgetDemo://action=%ld",sender.tag-110];
    [self.extensionContext openURL:[NSURL URLWithString:urlString] completionHandler:^(BOOL success) {
        if (success == YES) {
            NSLog(@"跳转成功");
        }
        else
        {
            NSLog(@"跳转失败");
        }
    }];
}


/**
 这是Widget改变展示样式时候的回调

 @param activeDisplayMode activeDisplayMode
 @param maxSize 尺寸
 */
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
 
    /**    
     这里加一个lastState参数是为了标记Widget上次的样式，如果上次和当前的样式一致，就不需要做动画，否则需要根据需求做相应的动画
     **/
    static BOOL lastState = NO;
    
    /**    这是一个改变Frame简单的动画    **/
    if(activeDisplayMode == NCWidgetDisplayModeCompact) {
        
        self.preferredContentSize = CGSizeMake(0, 110);
        
        if (lastState == NO) {
            lastState = YES;
            [UIView animateWithDuration:0.27 animations:^{
                _topView.frame = CGRectMake(0, 0, SC_WIDTH, 95);
                _titleLabel.frame = CGRectMake(15, -35, SC_WIDTH - 30, 30);
            }];
        }
        else
        {
            
            _topView.frame = CGRectMake(0, 0, SC_WIDTH, 95);
            _titleLabel.frame = CGRectMake(15, -35, SC_WIDTH - 30, 30);
        }
        
        
        
    } else {
        
        self.preferredContentSize = CGSizeMake(0, 240);
        
        if (lastState == YES) {
            lastState = NO;
            [UIView animateWithDuration:0.27 animations:^{
                _topView.frame = CGRectMake(0, 35, SC_WIDTH, 95);
                _titleLabel.frame = CGRectMake(15, 5, SC_WIDTH - 30, 30);
            }];
            
        }
        else
        {
            _topView.frame = CGRectMake(0, 35, SC_WIDTH, 95);
            _titleLabel.frame = CGRectMake(15, 5, SC_WIDTH - 30, 30);
            
        }
        
    }
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
