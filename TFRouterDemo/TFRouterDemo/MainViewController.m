//
//  MainViewController.m
//  TFRouterDemo
//
//  Created by zhutaofeng on 2020/7/21.
//  Copyright © 2020 ioser. All rights reserved.
//

#import "MainViewController.h"
#import "TFRouter.h"
@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bindRouterButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"路由";
    
    self.bindRouterButton.bindRouter = @"router://TestViewController0?routerType=push&userId=1234567890";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)push:(id)sender {
    [TFRouter routerTo:@"router://TestViewController0?routerType=push&userId=1234567890"];

}
- (IBAction)present:(id)sender {
    [TFRouter routerTo:@"router://TestViewController0?routerType=present&userId=1234567890"];
}

- (IBAction)sub:(id)sender {
    [TFRouter routerTo:@"router://TestViewController0?routerType=sub&userId=1234567890"];

}
- (IBAction)other:(id)sender {
    [TFRouter routerTo:@"http://www.baidu.com"];

}


@end
