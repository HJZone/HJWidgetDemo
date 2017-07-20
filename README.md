# HJWidgetDemo
--------------
   
   最终效果图   仿网易云音乐效果图（左）              仿支付宝效果图（右）  
   
<div align=center><img src="https://github.com/HJZone/HJWidgetDemo/blob/master/HJWidgetDemo/screenshots/012.png" width="375" height="667" >      <img src="https://github.com/HJZone/HJWidgetDemo/blob/master/HJWidgetDemo/screenshots/011.png" width="375" height="667">
   
    
   <div align=left>  
   
    
   ## 1.唤醒Containing APP     
        
        ```objc   
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

        
   ## 2.通过密码分享   
   sdsda
       
       
