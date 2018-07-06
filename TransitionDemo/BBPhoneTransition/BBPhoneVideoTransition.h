//
//  BBPhoneVideoTransition.h
//  TransitionDemo
//
//  Created by Aries on 2018/7/5.
//  Copyright © 2018年 Aries. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BBPhoneFromVideoTransitionProtocol <NSObject>

/** 返回执行Push的动画视图相对于下一视图的Frame */
- (CGRect)fromVideoTransitionAnimationViewFrame;

/** 返回执行Push的动画的视图 */
- (UIView *)fromVideoTransitionAnimationView;

@optional

/** 操作中止当前视图的手势Pop */
- (void)fromVideoTransitionCancel:(UIView *) animationView;

@end

@protocol BBPhoneToVideoTransitionProtocol <NSObject>

/** 返回执行Push的动画视图相对于下一视图的目标Frame */
- (CGRect)toVideoTransitionAnimationViewFrame;

/** 返回执行Push的下一视图的Frame */
- (CGRect)toVideoTransitionViewControllerFrame;

@optional

/** 视图切换完成后的回调 */
- (void)toVideoTransitionCompelete:(UIView *) animationView;

@end

@interface BBPhoneVideoTransition : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning>

/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;

/** 当需要手势触发pop时 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
