# HJWidgetDemo
--------------
   
   最终效果图   仿网易云音乐效果图（左）              仿支付宝效果图（右）  
   
<div align=center><img src="https://github.com/HJZone/HJWidgetDemo/blob/master/HJWidgetDemo/screenshots/012.png" width="375" height="667" >      <img src="https://github.com/HJZone/HJWidgetDemo/blob/master/HJWidgetDemo/screenshots/011.png" width="375" height="667">
   
    
   <div align=left>  
   
    
   ## 1.唤醒Containing APP  
   
   
    ```objc  
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
  
  ## 2.数据共享  
  
  通过NSFileManager来实现   
         存数据：   
  ```objc   
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
```

 取数据

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

