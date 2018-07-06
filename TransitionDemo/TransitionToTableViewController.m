//
//  TransitionToTableViewController.m
//  Demo
//
//  Created by Aries on 2018/7/4.
//  Copyright © 2018年 Aries. All rights reserved.
//

#import "TransitionToTableViewController.h"
#import "BBPhoneVideoTransition.h"
#import "TransitionNavigationViewController.h"
#import "Masonry.h"

@interface TransitionToTableViewController ()
<BBPhoneToVideoTransitionProtocol,
BBPhoneFromVideoTransitionProtocol,
UINavigationControllerDelegate>
@property (nonatomic, strong) BBPhoneVideoTransition * transition;
@end

@implementation TransitionToTableViewController
{
    UIView * _playerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ToVC";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.transition = [[BBPhoneVideoTransition alloc] init];
    [self.transition addPanGestureForViewController:self];
    self.navigationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - BBPhoneFromVideoTransitionProtocol

- (CGRect)fromVideoTransitionAnimationViewFrame
{
    return CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width /16.0 * 9.0);
}

- (UIView *)fromVideoTransitionAnimationView
{
    return _playerView;
}

- (void)fromVideoTransitionCancel:(UIView *)animationView
{
    [self toVideoTransitionCompelete:animationView];
}

#pragma mark - BBPhoneToVideoTransitionProtocol

- (CGRect)toVideoTransitionAnimationViewFrame
{
    return CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width /16.0 * 9.0);
}

- (CGRect)toVideoTransitionViewControllerFrame
{
    return [UIScreen mainScreen].bounds;
}

- (void)toVideoTransitionCompelete:(UIView *)animationView
{
    _playerView = animationView;
    [animationView removeFromSuperview];
    [self.view addSubview:animationView];
    CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width /16.0 * 9.0);
    [animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(frame.origin.x));
        make.top.equalTo(@(frame.origin.y));
        make.height.equalTo(@(frame.size.height));
        make.width.equalTo(@(frame.size.width));
    }];
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return self.transition;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    //手势开始的时候才需要传入手势过渡代理，如果直接点击pop，应该传入空，否者无法通过点击正常pop
    return _transition.interation ? _transition : nil;
}


@end
