//
//  RouterModel.h
//  nongpi
//
//  Created by zhutaofeng on 2019/6/12.
//  Copyright © 2019 shengnong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,RouterType) {
    RouterTypeWap = 0,
    RouterTypeLocal,
};


@interface RouterModel : NSObject

@property(nonatomic,assign) RouterType routerType;
@property(nonatomic,  copy) NSString *url;
@property(nonatomic,  copy) NSString *protocol;
@property(nonatomic,strong) NSDictionary *param;
@property(nonatomic,  weak) id controller;

@end

typedef void(^RouterObserverMsgBlock)(NSString *url,id object);
@interface RouterObserverMsgModel : NSObject

@property(nonatomic,  copy) NSString *url;
@property(nonatomic,  copy) RouterObserverMsgBlock msgBlock;

@end

