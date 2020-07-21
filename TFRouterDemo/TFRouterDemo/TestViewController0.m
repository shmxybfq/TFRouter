//
//  TestViewController0.m
//  TFRouterDemo
//
//  Created by zhutaofeng on 2020/7/21.
//  Copyright © 2020 ioser. All rights reserved.
//

#import "TestViewController0.h"
#import "TFRouter.h"
@interface TestViewController0 ()<RouterProtocol>

@property(nonatomic, copy) NSString *userId;

@end

@implementation TestViewController0

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新控制器";
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


+(NSString *)routerPath{
    return [NSString stringWithFormat:@"%@",NSStringFromClass([self class])];
}

+(id)routerInstanceWithParam:(NSDictionary *)param{
    
    NSString *userId = [param objectForKey:@"userId"];
    
    TestViewController0 *controller = [[TestViewController0 alloc]initWithNibName:NSStringFromClass([self class]) bundle:nil];
    controller.userId = userId;
    return controller;
}

@end


