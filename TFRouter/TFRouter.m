//
//  Router.m
//  nongpi
//
//  Created by zhutaofeng on 2019/6/11.
//  Copyright © 2019 shengnong. All rights reserved.
//

#import "TFRouter.h"
#import <objc/runtime.h>

@interface TFRouter ()

//是否已初始化
@property(nonatomic, assign) BOOL inited;
//已注册路由路径和控制器名称
@property(nonatomic, strong) NSMutableDictionary *routerMap;
//路由结果代理
@property(nonatomic, weak) id<RouterResultDelegate>delegate;
//
@property(nonatomic, strong) NSMutableDictionary *routered;
//
@property(nonatomic, strong) NSMutableArray <RouterObserverMsgModel*>*registeredMsgObserver;

@end

@implementation TFRouter

static TFRouter *_router;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _router = [[[self class] alloc]init];
    });
    return _router;
    
}

+(NSError *)routerTo:(NSString *)url{
    return [[TFRouter shareInstance]routerTo:url];
}

+(NSError *)routerTo:(NSString *)url obs:(RouterObserverBlock)obs{
    return [[TFRouter shareInstance]routerTo:url obs:obs];
}

+(NSError *)routerTo:(NSString *)url param:(NSDictionary *)param{
    NSString *prm = [param toRouterParam];
    return [TFRouter routerTo:[NSString stringWithFormat:@"%@?%@",url,prm]];
}

+(NSError *)routerTo:(NSString *)url param:(NSDictionary *)param obs:(RouterObserverBlock)obs{
    NSString *prm = [param toRouterParam];
    return [TFRouter routerTo:[NSString stringWithFormat:@"%@?%@",url,prm] obs:obs];
}

+(void)setRouterResultDeleget:(id<RouterResultDelegate>)delegate{
    [TFRouter shareInstance].delegate = delegate;
}

+(BOOL)sendMsg:(NSString *)url object:(id)object{
    if (url) {
        [[TFRouter shareInstance]sendMsg:url object:object];
        return YES;
    }
    return NO;
}
-(void)sendMsg:(NSString *)url object:(id)object{
    RouterModel *model = nil;
    NSString *routerKey = [NSString stringWithFormat:@"router://%@",url];
    NSArray *allKeys = self.routered.allKeys;
    for (NSString *key in allKeys) {
        if ([key hasPrefix:routerKey]) {
            model = [self.routered objectForKey:key];
        }
    }
    if (model.controller) {
        for (RouterObserverMsgModel *msgModel in self.registeredMsgObserver) {
            if ([url isEqualToString:msgModel.url] && msgModel.msgBlock) {
                msgModel.msgBlock(url, object);
            }
        }
    }
}

+(BOOL)observerMsg:(NSString *)url observerBlock:(RouterObserverMsgBlock)observerBlock{
    if (url || observerBlock) {
        [[TFRouter shareInstance]observerMsg:url observerBlock:observerBlock];
        return YES;
    }
    return NO;
}
-(void)observerMsg:(NSString *)url observerBlock:(RouterObserverMsgBlock)observerBlock{
    for (RouterObserverMsgModel *msgModel in self.registeredMsgObserver) {
        if ([msgModel.url isEqualToString:url]) {
            [self.registeredMsgObserver removeObject:msgModel];
            break;
        }
    }
    RouterObserverMsgModel *msgModel = [RouterObserverMsgModel new];
    msgModel.url = url;
    msgModel.msgBlock = observerBlock;
    [self.registeredMsgObserver addObject:msgModel];
}

-(NSError *)routerTo:(NSString *)url{
    return [self routerTo:url obs:nil];
}

-(NSError *)routerTo:(NSString *)url obs:(RouterObserverBlock)obs {
    if (!self.inited) {
        int count = objc_getClassList(NULL,0);
        Class *classes = (Class *)malloc(sizeof(Class) * count);
        objc_getClassList(classes, count);
        for (int i = 0; i < count; i++) {
            Class cls = classes[i];
            if (class_conformsToProtocol(cls, @protocol(RouterProtocol))) {
                SEL pathSel = @selector(routerPath);
                Method method = class_getClassMethod(cls, pathSel);
                if (method) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    NSString *path = [cls performSelector:pathSel];
#pragma clang diagnostic pop
                    if (path && [path isKindOfClass:[NSString class]] && path.length > 0) {
                        if (![self.routerMap objectForKey:path]) {
                            [self.routerMap setObject:NSStringFromClass(cls) forKey:path];
                        }else{
#ifdef DEBUG
                            NSString *errorMsg = [NSString stringWithFormat:@"router path repeat error:class[%@] and class[%@] router path same!",NSStringFromClass(cls),[self.routerMap objectForKey:path]];
                            NSAssert(NO, errorMsg);
#endif
                        }
                    }else{
#ifdef DEBUG
                        NSString *errorMsg = [NSString stringWithFormat:@"invalid router path  error:class[%@],please check your router configuration!",NSStringFromClass(cls)];
                        NSAssert(NO, errorMsg);
#endif
                    }
                }
            }
        }
        free(classes);
        self.inited = YES;
#ifdef DEBUG
        NSString *mark = @"===================== registed routers =====================";
        NSString *log = [NSString stringWithFormat:@"\n%@\n%@\n%@",
                         mark,
                         self.routerMap?:@"无",
                         mark];
        NSLog(@"%@",log);
#endif
    }
    if (url && [url hasPrefix:@"http"]) {
        if ([self.delegate respondsToSelector:@selector(routerResult:)]) {
            RouterModel *model = [RouterModel new];
            model.routerType = RouterTypeWap;
            model.url = url;
            model.param = nil;
            model.protocol = nil;
            model.controller = nil;
            if (obs) {
                obs(model);
            }
            [self routerResultPre:model];
        }
    }else if(url && [url hasPrefix:@"router"]){
        NSString *protocol = [TFRouter parseProtocolFromUrl:url];
        protocol = [protocol stringByReplacingOccurrencesOfString:@"router://" withString:@""];
        NSString *clsString = [self.routerMap objectForKey:protocol];
        if (clsString) {
            Class cls = NSClassFromString(clsString);
            NSDictionary *param = [TFRouter parseParamFromUrl:url];
            SEL instanceSel = @selector(routerInstanceWithParam:);
            Method method = class_getClassMethod(cls, instanceSel);
            if (method) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                id controller = [cls performSelector:instanceSel withObject:param];
#pragma clang diagnostic pop
                if (controller && [controller isKindOfClass:[UIViewController class]]) {
                    RouterModel *model = [RouterModel new];
                    model.routerType = RouterTypeLocal;
                    model.url = url;
                    model.param = param;
                    model.protocol = [TFRouter parseProtocolFromUrl:url];
                    model.controller = controller;
                    if (obs) {
                        obs(model);
                    }
                    [self routerResultPre:model];
                }else{
#ifdef DEBUG
                    NSString *mark = @"===================== router error! =====================";
                    NSString *log = [NSString stringWithFormat:@"\n%@\n%@\n%@",
                                     mark,
                                     [NSString stringWithFormat:@"router url:[%@] please configure the correct controller!",url],
                                     mark];
                    NSLog(@"%@",log);
#endif
                }
            }
        }else{
#ifdef DEBUG
            NSString *mark = @"===================== router error! =====================";
            NSString *log = [NSString stringWithFormat:@"\n%@\n%@\n%@",
                             mark,
                             [NSString stringWithFormat:@"router url:[%@] please re-add the controller:%@",url,clsString],
                             mark];
            NSLog(@"%@",log);
#endif
        }
    }else{
        //其他
    }
    return nil;
}

-(void)routerResultPre:(RouterModel *)model{
#ifdef DEBUG
    NSString *mark = @"===================== 路由到 =====================";
    NSString *controllerString = @"";
    if (model.controller) {
        UIViewController *con = model.controller;
        Class cls = [con class];
        NSString *name = [NSString stringWithFormat:@"[%@]",NSStringFromClass(cls)];
        NSString *addr = [NSString stringWithFormat:@"[address:%p]",con];
        NSString *title = [NSString stringWithFormat:@"[title:%@]",con.title?:@""];
        NSString *view = [NSString stringWithFormat:@"[view:%@]",con.view];
        NSString *total = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",name,addr,title,view];
        
        NSMutableString *supCls = [[NSMutableString alloc]init];
        while (YES) {
            [supCls appendString:@"-"];
            [supCls appendFormat:@"%@",NSStringFromClass([cls superclass])];
            cls = [cls superclass];
            if ([NSStringFromClass(cls) isEqualToString:@"NSObject"]) {
                break;
            }
        }
        controllerString = [NSString stringWithFormat:@"%@\n[super:%@]",total,supCls];
    }
    NSString *log = [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",
                     mark,
                     [NSString stringWithFormat:@"routerType: [%@]",@(model.routerType)],
                     [NSString stringWithFormat:@"url: [%@]",model.url?:@""],
                     [NSString stringWithFormat:@"param: [%@]",model.param?:@""],
                     [NSString stringWithFormat:@"protocol: [%@]",model.protocol?:@""],
                     [NSString stringWithFormat:@"\n--------- controller ---------"],
                     [NSString stringWithFormat:@"%@",controllerString?:@""],
                     [NSString stringWithFormat:@"--------- controller ---------\n"],
                     mark];
    NSLog(@"%@",log);
    
#endif
    if ([self.delegate respondsToSelector:@selector(routerResult:)]) {
        [((NSObject *)self.delegate)performSelectorOnMainThread:@selector(routerResult:)
                                                     withObject:model
                                                  waitUntilDone:YES];
        [self.routered setObject:model forKey:model.url];
        //每次触发路由的时候刷新监听器,移除已经不在的监听
        [self refreshRoutered];
    }else{
#ifdef DEBUG
        NSString *mark = @"===================== router error! =====================";
        NSString *log = [NSString stringWithFormat:@"\n%@\n%@\n%@",
                         mark,
                         @"Routing protocols[RouterResultDelegate] must be implemented !",
                         mark];
        NSLog(@"%@",log);
#endif
    }
}

-(void)refreshRoutered{
    NSArray *allkeys = [NSArray arrayWithArray:self.routered.allKeys];
    for (NSString *key in allkeys) {
        RouterModel *model = [self.routered objectForKey:key];
        if (!model.controller) {
            [self.routered removeObjectForKey:key];
            NSArray *tmp = [NSArray arrayWithArray:self.registeredMsgObserver];
            for (RouterObserverMsgModel *msgModel in tmp) {
                if ([key containsString:msgModel.url]) {
                    [self.registeredMsgObserver removeObject:msgModel];
                }
            }
        }
    }
}

+(NSString *)parseProtocolFromUrl:(NSString *)url{
    if ((!url) || (![url isKindOfClass:[NSString class]])) return nil;
    if ([url rangeOfString:@"?"].location != NSNotFound) {
        NSArray *comp = [url componentsSeparatedByString:@"?"];
        return comp.firstObject;
    }else{
        return url;
    }
}

+(NSDictionary *)parseParamFromUrl:(NSString *)url{
    if ((!url) || (![url isKindOfClass:[NSString class]])) return nil;
    if ([url rangeOfString:@"?"].location != NSNotFound) {
        NSArray *comp = [url componentsSeparatedByString:@"?"];
        if (comp.count == 2) {
            NSString *paramString = comp.lastObject;
            NSArray  *paramBlock  = [paramString componentsSeparatedByString:@"&"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            for (NSString *param in paramBlock) {
                NSArray *p = [param componentsSeparatedByString:@"="];
                if (p.count == 2) {
                    NSString *p0 = [p objectAtIndex:0];
                    NSString *p1 = [p objectAtIndex:1];
                    if (p0 && p1) {
                        [dic setObject:p1 forKey:p0];
                    }
                }
            }
            return dic;
        }
    }else{
        return nil;
    }
    return nil;
}

-(NSMutableDictionary *)routerMap{
    if (!_routerMap) {
        _routerMap = [[NSMutableDictionary alloc]init];
    }
    return _routerMap;
}

-(NSMutableDictionary *)routered{
    if (!_routered) {
        _routered = [NSMutableDictionary dictionary];
    }
    return _routered;
}

-(NSMutableArray *)registeredMsgObserver{
    if (!_registeredMsgObserver) {
        _registeredMsgObserver = [[NSMutableArray alloc]init];
    }
    return _registeredMsgObserver;
}

@end


