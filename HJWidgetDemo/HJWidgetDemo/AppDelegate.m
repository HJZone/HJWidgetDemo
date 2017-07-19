//
//  AppDelegate.m
//  HJWidgetDemo
//
//  Created by 浩杰 on 2017/7/18.
//  Copyright © 2017年 haojie. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*
     这是一个Containing APP和Today extension之间共享数据的例子，是由Containing APP共享数据到Today Extension；
     在这里，我们用NSUserDefaults的方法，存一个BOOL类型的值，需要注意的是，由于Containing APP 和Today Extension之间是相对独立的Target，所以这里的NSUserDefaults初始化方法也和我们平时用的不一样，需要使用initWithSuiteName来初始化，这个套装名称是在APP Groups里边添加的Item
     */
    NSUserDefaults *sharedDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.hjfirst"];
    [sharedDefault setBool:YES forKey:@"isSendData"];
    [sharedDefault synchronize];
    // Override point for customization after application launch.
    return YES;
}



/**
 处理Widget相关事件，这个方法来自<UIApplicationDelegate>
 因此不需要其他声明的代码，只要写出来就会在适当的时候调用
 但是这个方法在iOS 9.0的时候就被弃用了，用application:openURL:options:这个方法代替

 @param application application
 @param url Open URL，也就是在跳转时候你使用的那个地址
 @param sourceApplication sourceApplication，这个参数在iOS 10.3上获取不到，可能在iOS 8.0到iOS 9.0之间的系统可以获取到吧
 @param annotation 注释
 @return return value
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    /**    这是一个获取Today Extension数据的例子    **/
    NSUserDefaults *sharedDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.hjfirst"];
    NSLog(@"共享的数据 ： %@",[sharedDefault objectForKey:@"firstStatus"]);
    
    NSLog(@"sourceApplication : %@",sourceApplication);
    [self handelAppTransformWithUrl:url];
    
    return  YES;
}


/**
 这个方法是代替上一个方法的，是从iOS 9.0出现的方法

 @param app application
 @param url 链接地址
 @param options 附加的一些参数
 @return return value
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    
    [self handelAppTransformWithUrl:url];
    return YES;
}


/**
 处理APP跳转事件

 @param url 跳转的链接
 */
- (void)handelAppTransformWithUrl:(NSURL *)url
{
    NSLog(@"url : %@",url.absoluteString);
    NSInteger index = [[[url.absoluteString componentsSeparatedByString:@"="] lastObject] integerValue];
    
    NSString *titleString = @"";
    
    switch (index) {
        case 0://扫一扫
        {
            titleString = @"扫一扫";
        }
            break;
        case 1://付款
        {
            titleString = @"付款";
        }
            break;
        case 2://收钱
        {
            titleString = @"收钱";
        }
            break;
        case 3://转账
        {
            titleString = @"转账";
        }
            break;
        case 10://扫一扫
        {
            titleString = @"陪你工作";
        }
            break;
        case 11://付款
        {
            titleString = @"私人FM";
        }
            break;
        case 12://收钱
        {
            titleString = @"下载的音乐";
        }
            break;
        case 13://转账
        {
            titleString = @"听歌识曲";
        }
            break;
            
        default:
            break;
    }
    
    [self addAlertTitle:titleString message:nil withCancelButton:@"知道了" confirmButton:nil withClickConfirmBlock:nil withCancelBlock:nil];
}

/**    这是封装的一个快速添加一个AlertController的方法    **/
- (void)addAlertTitle:(NSString*)titleString message:(NSString*)messageString withCancelButton:(NSString*)cancelTitle confirmButton:(NSString*)confirmTitle withClickConfirmBlock:(void (^)())confirm withCancelBlock:(void (^)())cancelBlock
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:titleString message:messageString preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    if (confirmTitle != nil) {
        [alert addAction:[UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
            
            if (confirm != nil) {
                confirm();
            }
            
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action) {
        if (cancelBlock != nil) {
            cancelBlock();
        }
        
    }]];
    
    
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}




@end
