//
//  BBPhoneVideoTransition.m
//  TransitionDemo
//
//  Created by Aries on 2018/7/5.
//  Copyright © 2018年 Aries. All rights reserved.
//

#import "BBPhoneVideoTransition.h"
#import "BBPhoneInfoTransitionAnimationView.h"

@interface BBPhoneVideoTransition()

/** 手势触发时需要调用的VC */
@property (nonatomic, weak) UIViewController *vc;

/** 手势pop的取消 */
@property (nonatomic, assign) BOOL cancel;

/** 手势区域 */
@property (nonatomic, strong) UIView * panView;

@end

@implementation BBPhoneVideoTransition
{
    __weak UIViewController<BBPhoneToVideoTransitionProtocol> * _toViewController;
    __weak UIViewController<BBPhoneFromVideoTransitionProtocol> * _fromViewController;
    
}

#pragma mark - PublicMethods

- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    
    UIView * panView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewController.view.frame.size.width * 0.2, viewController.view.frame.size.height)];
    [viewController.view addSubview:panView];
    self.panView = panView;
    self.vc = viewController;
    [panView addGestureRecognizer:pan];
}

- (void)dealloc
{
    [self.panView removeFromSuperview];
    self.panView = nil;
    NSLog(@"aries: %@",NSStringFromClass([self class]));
}

#pragma mark - PrivateMethods

/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    //手势百分比
    CGFloat persent = 0;
    CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
    persent = transitionX / panGesture.view.frame.size.width;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态，并开始相应的事件
            self.interation = YES;
            [self startGesture];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过比例，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            self.interation = NO;
            if (persent > 0.3) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
                self.cancel = YES;
                if (_fromViewController && [_fromViewController respondsToSelector:@selector(fromVideoTransitionCancel:)]) {
                    [_fromViewController fromVideoTransitionCancel: [self transitionAnimationView]];
                }
            }
            break;
        }
        default:
            break;
    }
}

- (void)startGesture{
    [_vc.navigationController popViewControllerAnimated:YES];
}

- (void)animateTransitionNormal:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    _fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    BBPhoneInfoTransitionAnimationView * trasitionView = [[BBPhoneInfoTransitionAnimationView alloc] initWithFrame:CGRectZero];
    
    /** containView */
    UIView *containView = [transitionContext containerView];
    containView.backgroundColor = [self containViewBackgroundColor];
    [containView addSubview:trasitionView];
    trasitionView.frame = [self toViewControllerFrame];
    
    /** Transition */
    UIView * animationView = [self transitionAnimationView];
    CGRect animationViewFromFrame = [self transitionAnimationViewFromFrame];
    CGRect animationViewToFrame = [self transitionAnimationViewToFrame];
    [trasitionView addRootController:_toViewController];
    [trasitionView addAnimationView:animationView WithFrame:animationViewFromFrame];
    __weak UIViewController<BBPhoneToVideoTransitionProtocol> * toViewController = _toViewController;
    __weak UIViewController<BBPhoneFromVideoTransitionProtocol> * fromViewController = _fromViewController;
    __weak typeof(self) weakSelf = self;
    [trasitionView annimationWithDuration:[self transitionDuration:transitionContext] toFrame:animationViewToFrame WithAnimation:^{
    } withComplete:^(UIView *animationView) {
        if (weakSelf.cancel) {
            [trasitionView removeFromSuperview];
            [fromViewController viewWillAppear:YES];
            [fromViewController viewDidAppear:YES];
            weakSelf.cancel = NO;
            [transitionContext completeTransition:NO];
            return;
        }
        if (toViewController && [toViewController respondsToSelector:@selector(toVideoTransitionCompelete:)]) {
            [toViewController toVideoTransitionCompelete: animationView];
        }
        [trasitionView removeRootController];
        [transitionContext completeTransition:YES];
    }];
}

- (UIColor *)containViewBackgroundColor
{
    return [UIColor whiteColor];
}

#pragma mark - BBPhoneVideoTransitionFromViewControllerDelegate

- (CGRect)transitionAnimationViewFromFrame
{
    CGRect frame = CGRectZero;
    if (_fromViewController && [_fromViewController respondsToSelector:@selector(fromVideoTransitionAnimationViewFrame)]) {
        frame = [_fromViewController fromVideoTransitionAnimationViewFrame];
    }
    return frame;
}

- (UIView *)transitionAnimationView
{
    UIView * view = nil;
    if (_fromViewController && [_fromViewController respondsToSelector:@selector(fromVideoTransitionAnimationView)]) {
        view = [_fromViewController fromVideoTransitionAnimationView];
    }
    return view;
}

#pragma mark - BBPhoneVideoTransitionToViewControllerDelegate

- (CGRect)transitionAnimationViewToFrame
{
    CGRect frame = CGRectZero;
    if (_toViewController && [_toViewController respondsToSelector:@selector(toVideoTransitionAnimationViewFrame)]) {
        frame = [_toViewController toVideoTransitionAnimationViewFrame];
    }
    return frame;
}

- (CGRect)toViewControllerFrame
{
    CGRect frame = CGRectZero;
    if (_toViewController && [_toViewController respondsToSelector:@selector(toVideoTransitionViewControllerFrame)]) {
        frame = [_toViewController toVideoTransitionViewControllerFrame];
    }
    return frame;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.15;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    [self animateTransitionNormal:transitionContext];
}

@end
