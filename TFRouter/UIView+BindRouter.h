//
//  UIView+BindRouter.h
//  nongpi
//
//  Created by zhutaofeng on 2020/1/6.
//  Copyright © 2020 shengnong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BindViewTapGesActionBlock)(UITapGestureRecognizer *tapGes);

@interface UIView (BindRouter)

@property(nonatomic,   copy) NSString *bindRouter;
@property(nonatomic, strong) UITapGestureRecognizer *bindRouterTapGes;
@property(nonatomic,   copy) BindViewTapGesActionBlock tapBlock;

-(void)tapAction:(BindViewTapGesActionBlock)tapBlock;

@end

NS_ASSUME_NONNULL_END
