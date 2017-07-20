# HJWidgetDemo
--------------
    
        
    
   <div align=center>仿网易云音乐效果图（左）              仿支付宝效果图（右）  
   
<img src="https://github.com/HJZone/HJWidgetDemo/blob/master/HJWidgetDemo/screenshots/012.png" width="375" height="667" >      <img src="https://github.com/HJZone/HJWidgetDemo/blob/master/HJWidgetDemo/screenshots/011.png" width="375" height="667">
   
    
   <div align=left>  
   
    
 # 1.唤醒Containing APP     
   
   ```objc 
   /*
     这里的URL是有固定格式的，://前边的“hjWidgetDemo”是Containing APP添加的URL Types里添加的URL Schemes，这里是必须一致，否则会跳转失败的
     */
    NSString *urlString = [NSString stringWithFormat:@"hjWidgetDemo://action=%ld",sender.tag];
    
    [self.extensionContext openURL:[NSURL URLWithString:urlString] completionHandler:^(BOOL success) {
        if (success == YES) {
            NSLog(@"跳转成功");
        }
        else
        {
            NSLog(@"跳转失败");
        }
    }];
```

# 2.数据共享
   
      
  ## 通过NSFileManager来实现数据共享    
   
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
```


## 通过NSUserDefaults来实现数据共享    

存数据：
```objc
   /**    这里是采用NSUserDefaults来实现   **/
    NSUserDefaults *sharedDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.hjfirst"];
    [sharedDefault setObject:@{@"name" : [_titleArray objectAtIndex:sender.tag]} forKey:@"firstStatus"];
    [sharedDefault setBool:NO forKey:@"isSendData"];
    [sharedDefault synchronize];
 ```


取数据   

```objc
    /**    这是一个获取Today Extension数据的例子    **/
    NSUserDefaults *sharedDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.hjfirst"];
    NSLog(@"共享的数据 ： %@",[sharedDefault objectForKey:@"firstStatus"]);
```




 
 
 
 [ 点击跳转到相关博客 ]:(http://blog.csdn.net/drunkard_001/article/details/75393965 )
 

