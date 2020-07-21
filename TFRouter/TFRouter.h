//
//  Router.h
//  nongpi
//
//  Created by zhutaofeng on 2019/6/11.
//  Copyright © 2019 shengnong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "RouterModel.h"
#import "NSArray+Router.h"
#import "NSDictionary+Router.h"
#import "RouterUnit.h"
#import "UIView+BindRouter.h"

/** 路由协议,需要路由的控制器必须显示的在本类实现协议头 RouterProtocol
 * 并且需要同时实现下面两个协议方法
 */
@protocol RouterProtocol <NSObject>
@required
+(NSString *)routerPath;
+(id)routerInstanceWithParam:(NSDictionary *)param;
@end


/** 路由结果协议,路由将把路由的结果回调到如下协议的方法
 * app可以通过下面方法完成自己的业务逻辑,
 */
@protocol RouterResultDelegate <NSObject>
@required
-(void)routerResult:(RouterModel *)model;
@end


@interface TFRouter : NSObject


//路由到某url
+(NSError *)routerTo:(NSString *)url;
//设置路由结果代理
+(void)setRouterResultDeleget:(id<RouterResultDelegate>)delegate;



//向已路由过并且还未释放的控制器发送消息
+(BOOL)sendMsg:(NSString *)url object:(id)object;
//接收路由消息
+(BOOL)observerMsg:(NSString *)url observerBlock:(RouterObserverMsgBlock)observerBlock;


//从url中解析出除参数部分
+(NSString *)parseProtocolFromUrl:(NSString *)url;
//从url中解析出参数
+(NSDictionary *)parseParamFromUrl:(NSString *)url;

@end


