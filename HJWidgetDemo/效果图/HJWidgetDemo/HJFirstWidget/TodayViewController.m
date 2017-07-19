//
//  TodayViewController.m
//  HJFirstWidget
//
//  Created by 浩杰 on 2017/7/18.
//  Copyright © 2017年 haojie. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "HJImageTitleButton.h"



#define SC_WIDTH    [UIScreen mainScreen].bounds.size.width//屏幕宽度
#define SC_HEIGHT   [UIScreen mainScreen].bounds.size.height//屏幕高度
#define RGB_COLOR(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1] //宏定义一个设置RGB颜色的方法


/**    这里遵循的NCWidgetProviding协议是我们添加Today Extension时候系统默认的，无需手动添加    **/
@interface TodayViewController () <NCWidgetProviding>

/** 图片数组 **/
@property (nonatomic , strong) NSArray *imageArray;

/** 标题数组 **/
@property (nonatomic , strong) NSArray *titleArray;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**    这里是设置Widget的高度，默认为110，除了用这个属性来设置Widget的高度外，也可以通过代理协议来设置（- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets），但是通过代理来设置的方法在iOS 10.0被废弃了，不管是从简易程度还是从方法是否废弃来说，通过preferredContentSize这个属性来设置都是最佳的选择
     **/
    self.preferredContentSize = CGSizeMake(0, 110);
    
    /**    添加一些页面控件    **/
    [self setUpUI];
    
    /**    这个是获取从Containing APP共享过来的数据    **/
    NSUserDefaults *sharedDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.hjfirst"];
    if ([sharedDefault boolForKey:@"isSendData"] == YES) {
        NSLog(@"接收到数据");
    }
    
    
}


/**
 添加需要的控件
 */
- (void)setUpUI
{
    _imageArray = @[@"saoyisao",@"fukuan",@"shouqian",@"zhuanzhang"];
    _titleArray = @[@"扫一扫",@"付款",@"收钱",@"转账"];
    
    for (int a = 0; a < _imageArray.count; a ++) {
        
        CGFloat itemHeight = 70.f;
        CGFloat width = SC_WIDTH * 0.95;
        
        HJImageTitleButton *btn = [[HJImageTitleButton alloc] initWithImageName:_imageArray[a] withTitle:_titleArray[a] withTitleFont:[UIFont systemFontOfSize:12] withType:HJImageButtonTypeForUpAndDown];
        btn.frame = CGRectMake((width - itemHeight * 4)/4 * (a % 4) + itemHeight * (a % 4) + (width - itemHeight * 4)/8, 10, itemHeight, itemHeight);
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btn setIconScaleWithScale:0.5];
        [btn setIconToTitleSpaceScale:0.7];
        [btn setTitleColor:RGB_COLOR(92, 102, 79) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn.tag = 120 + a;
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}


/**
 按钮点击方法

 @param sender 按钮
 */
- (void)buttonClick:(HJImageTitleButton *)sender
{
    
    
    //数据共享的话是通过NSUserDefaults或者NSFileManager来完成的
    
    /**    这里是采用NSUserDefaults来实现   **/
    NSUserDefaults *sharedDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.hjfirst"];
    [sharedDefault setObject:@{@"name" : [_titleArray objectAtIndex:sender.tag - 120]} forKey:@"firstStatus"];
    [sharedDefault setBool:NO forKey:@"isSendData"];
    [sharedDefault synchronize];

    /*
     这里的URL是有固定格式的，://前边的“hjWidgetDemo”是Containing APP添加的URL Types里添加的URL Schemes，这里是必须一致，否则会跳转失败的
     */
    NSString *urlString = [NSString stringWithFormat:@"hjWidgetDemo://action=%ld",sender.tag-120];
    
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
 通过NSFileManager存数据

 @return 是否存储成功
 */
- (BOOL)saveDataByNSFileManager
{
    NSError *err = nil;
    
    /**    这里的groupIdentifier是在APP Groups里添加的Item    **/
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.hjfirst"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/widget"];
    
    NSString *value = @"你要存的内容";
    BOOL result = [value writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!result)
    {
        NSLog(@"存入数据失败，原因 ： %@",err);
    }
    else
    {
        NSLog(@"存入数据成功，数据 : %@ success.",value);
    }
    return result;
}


/**
 通过NSFileManager读取数据

 @return 读取到的数据
 */
- (NSString *)readDataByNSFileManager
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.hjfirst"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/widget"];
    NSString *value = [NSString stringWithContentsOfURL:containerURL encoding:NSUTF8StringEncoding error:&err];
    return value;
}




- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
