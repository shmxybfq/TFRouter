
# TFRouter

🚀🚀🚀一个很好用的iOS路由器~

[![License MIT](https://img.shields.io/badge/License-MIT-orange)]()&nbsp;
[![Platform iOS](https://img.shields.io/badge/platform-iOS-grayblue)]()&nbsp;
<br/>

## 功能和特点
 
 **灵活** 此路由作为一个独立消息通道可以完全自己控制跳转方式 <br>
 **简单** 使用非常简单，配置好后，其他页面复制即可<br>
 **不耦合** 不影响控制器原有功能等，可用可不用 <br>
 
## 使用

### 在控制器实现路由协议
```
<RouterProtocol>
```

### 并实现协议的方法，例如：
```
//返回一个唯一id字符串匹配当前控制器，一般用类名比较好
+(NSString *)routerPath{
    return [NSString stringWithFormat:@"%@",NSStringFromClass([self class])];
}
//有路由跳转到本控制器时调用，param为跳转过来时携带的参数，此方法需要返回当前控制器的实例
+(id)routerInstanceWithParam:(NSDictionary *)param{
    
    NSString *userId = [param objectForKey:@"userId"];
    
    TestViewController0 *controller = [[TestViewController0 alloc]initWithNibName:NSStringFromClass([self class]) bundle:nil];
    controller.userId = userId;
    return controller;
}
```
### 在合适的地方实现路由总协议RouterResultDelegate
```
<RouterResultDelegate>
```
### 设置路由协议的实现代理对象
```
[TFRouter setRouterResultDeleget:self];
```
### 实现路由总协议RouterResultDelegate的唯一一个方法
```
//所有的路由都经过此方法，可以在此方法根据路由类型和参数来开发路由方式
-(void)routerResult:(RouterModel *)model{
   NSLog(@"routerType:%@",@(model.routerType));//路由类型，包括本地路由和http路由
   NSLog(@"url:%@",model.url);//路由的整个url
   NSLog(@"protocol:%@",model.protocol);//路由的协议
   NSLog(@"NSDictionary:%@",model.param);//路由携带的参数字典
   NSLog(@"controller:%@",model.controller);//需要路由的控制器
}
```

### 使用示例
```
[TFRouter routerTo:@"router://TestViewController0?routerType=push&userId=1234567890"];
```

### UI组件直接绑定路由用法
```
//此为代码绑定，也可以直接xib上动态绑定，提高开发效率。
someView.bindRouter = @"router://TestViewController0?routerType=push&userId=1234567890";

```

## 安装
```
pod 'TFRouter'

```


## 如果
使用过程中有bug，请随时issues我或者联系我；
现有功能满足不了你的需求，请随时issues我或者联系我；
有更好的建议或者优化，请随时issues我或者联系我；
QQ:927141965,邮箱shmxybfq@163.com
