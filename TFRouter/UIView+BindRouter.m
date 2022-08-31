//
//  UIView+BindRouter.m
//  nongpi
//
//  Created by zhutaofeng on 2020/1/6.
//  Copyright © 2020 shengnong. All rights reserved.
//

#import "UIView+BindRouter.h"
#import <objc/runtime.h>
//#import "Router.h"
#import "TFRouter.h"

@implementation UIView (BindRouter)

@dynamic bindRouter,bindRouterTapGes,tapBlock;

-(void)routerTapAction:(BindViewTapGesActionBlock)tapBlock{
    self.tapBlock = tapBlock;
}

-(BindViewTapGesActionBlock)tapBlock{
    id value = objc_getAssociatedObject(self, @selector(tapBlock));
    if (value)return value;
    return nil;
}

-(void)setTapBlock:(BindViewTapGesActionBlock)tapBlock{
    objc_setAssociatedObject(self, @selector(tapBlock), tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addAction];
}

-(NSString *)bindRouter{
    id value = objc_getAssociatedObject(self, @selector(bindRouter));
    if (value)return value;
    return nil;
}

-(void)setBindRouter:(NSString *)bindRouter{
    objc_setAssociatedObject(self, @selector(bindRouter), bindRouter, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addAction];
}

-(void)addAction{
    if ([self isKindOfClass:[UIControl class]]) {
        UIControl *control = (UIControl *)self;
        [control removeTarget:self action:@selector(router_bindRouterAction) forControlEvents:UIControlEventTouchUpInside];
        [control addTarget:self action:@selector(router_bindRouterAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self removeGestureRecognizer:self.bindRouterTapGes];
        self.bindRouterTapGes = nil;
        self.bindRouterTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(router_bindRouterAction)];
        [self addGestureRecognizer:self.bindRouterTapGes];
    }
}

-(UITapGestureRecognizer *)bindRouterTapGes{
    id value = objc_getAssociatedObject(self, @selector(bindRouterTapGes));
    if (value){
        return value;
    }
    return value;
}

-(void)setBindRouterTapGes:(UITapGestureRecognizer *)bindRouterTapGes{
    objc_setAssociatedObject(self, @selector(bindRouterTapGes), bindRouterTapGes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)router_bindRouterAction{
    if(self.tapBlock){
        if ([self isKindOfClass:[UIControl class]]) {
            self.tapBlock(nil);
        }else{
            self.tapBlock(self.bindRouterTapGes);
        }
    }else if (self.bindRouter && [self.bindRouter isKindOfClass:[NSString class]] && self.bindRouter.length > 0) {
        [TFRouter routerTo:self.bindRouter];
    }
}


@end

