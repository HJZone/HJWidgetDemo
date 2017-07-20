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
    }];```

2.数据共享
