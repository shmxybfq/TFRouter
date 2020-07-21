//
//  AppDelegate.m
//  TFRouterDemo
//
//  Created by zhutaofeng on 2020/7/21.
//  Copyright © 2020 ioser. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@interface AppDelegate ()

@property(nonatomic, weak) UINavigationController *nav;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#if defined(__IPHONE_13_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if(@available(iOS 13.0,*)){
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
#endif
    MainViewController *mainController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainController];
    self.window.rootViewController = nav;
    self.nav = nav;
    [self.window makeKeyAndVisible];
    
    [TFRouter setRouterResultDeleget:self];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(void)routerResult:(RouterModel *)model{
    
    NSLog(@"routerType:%@",@(model.routerType));
    NSLog(@"url:%@",model.url);
    NSLog(@"protocol:%@",model.protocol);
    NSLog(@"NSDictionary:%@",model.param);
    NSLog(@"controller:%@",model.controller);
    
    if (model.routerType == RouterTypeLocal) {
        NSString *routerType = [model.param objectForKey:@"routerType"];
        if ([routerType isEqualToString:@"push"]) {
            
            [self.nav pushViewController:model.controller animated:YES];
            
        }else if ([routerType isEqualToString:@"present"]) {
            
            [self.nav presentViewController:model.controller animated:YES completion:nil];
            
        }else if ([routerType isEqualToString:@"sub"]) {
            
            UIViewController *controller = self.nav.viewControllers.lastObject;
            [controller addChildViewController:model.controller];
            [controller.view addSubview:((UIViewController *)model.controller).view];
            
        }else{
            
        }
        
    }else if(model.routerType == RouterTypeWap){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url] options:nil completionHandler:nil];
        
    }
}




@end
