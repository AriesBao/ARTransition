//
//  BBPhoneInfoTransitionAnimationViewController.m
//  BBPhone
//
//  Created by Aries on 2018/7/2.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import "BBPhoneInfoTransitionAnimationView.h"
#import "Masonry.h"

@interface BBPhoneInfoTransitionAnimationView ()

@property (nonatomic, weak) UIViewController * rootController;

@property (nonatomic, strong) UIView * animationView;

@end

@implementation BBPhoneInfoTransitionAnimationView


- (void) setAnimationView:(UIView *)animationView
{
    _animationView = animationView;
}

- (void)annimationWithDuration:(NSTimeInterval) duration toFrame:(CGRect) toFrame WithAnimation:(void(^)()) animationBlock  withComplete:(void(^)(UIView * animationView)) complete
{
    __weak typeof(self) weakSelf = self;
    
    [_animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(toFrame.origin.x));
        make.top.equalTo(@(toFrame.origin.y));
        make.height.equalTo(@(toFrame.size.height));
        make.width.equalTo(@(toFrame.size.width));
    }];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.rootController.view.alpha = 1;
        [weakSelf layoutIfNeeded];
        if (animationBlock) {
            animationBlock();
        }
    } completion:^(BOOL finished) {
        if (complete) {
            complete(weakSelf.animationView);
        }
        weakSelf.animationView = nil;
    }];
}

- (void)dealloc
{
    NSLog(@"aries: %@",NSStringFromClass([self class]));
}

- (void)addRootController:(UIViewController *) controller
{
    self.rootController = controller;
    controller.view.frame = self.bounds;
    controller.view.alpha = 0;
    [self addSubview:controller.view];
}

- (void)removeRootController
{
    if (self.rootController && self.superview) {
        [self.rootController.view removeFromSuperview];
        self.rootController.view.frame = self.bounds;
        self.rootController.view.alpha = 1;
        [self.superview addSubview:self.rootController.view];
        [self removeFromSuperview];
    }
}

- (void)addAnimationView:(UIView *) view WithFrame:(CGRect) frame
{
    self.animationView = view;
    [view removeFromSuperview];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(frame.origin.x));
        make.top.equalTo(@(frame.origin.y));
        make.height.equalTo(@(frame.size.height));
        make.width.equalTo(@(frame.size.width));
    }];
    [self layoutIfNeeded];
    
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
