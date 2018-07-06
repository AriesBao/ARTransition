//
//  BBPhoneInfoTransitionAnimationViewController.h
//  BBPhone
//
//  Created by Aries on 2018/7/2.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBPhoneInfoTransitionAnimationView : UIView

- (void) addRootController:(UIViewController *) controller;

- (void)removeRootController;

- (void)addAnimationView:(UIView *) view WithFrame:(CGRect) frame;

- (void)annimationWithDuration:(NSTimeInterval) duration toFrame:(CGRect) toFrame WithAnimation:(void(^)()) animationBlock  withComplete:(void(^)(UIView * animationView)) complete;

@end
