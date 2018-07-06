//
//  TransitionFromTableViewController.m
//  Demo
//
//  Created by Aries on 2018/7/4.
//  Copyright © 2018年 Aries. All rights reserved.
//

#import "TransitionFromTableViewController.h"
#import "TransitionToTableViewController.h"
#import "BBPhoneVideoTransition.h"
#import "TransitionNavigationViewController.h"
#import "Masonry.h"

@interface TransitionCell: UITableViewCell

@property (nonatomic, weak) UIView * playerView;

@end

@implementation TransitionCell

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor grayColor];
        self.playerView = view;
        [self.contentView addSubview:view];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@8);
            make.right.equalTo(@(-8));
            make.top.equalTo(@(8));
            make.bottom.equalTo(@(-8));
        }];
        
    }
    return self;
}

- (void)addPlayer:(UIView *) player
{
    [player removeFromSuperview];
    self.playerView = player;
    [self.contentView addSubview:player];
    [player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.right.equalTo(@(-8));
        make.top.equalTo(@(8));
        make.bottom.equalTo(@(-8));
    }];
}

@end

@interface TransitionFromTableViewController ()
<BBPhoneFromVideoTransitionProtocol,
BBPhoneToVideoTransitionProtocol>
{
    __weak UIView * _transitionAnimationView;
    __weak TransitionCell * _cell;
    CGRect _transitionAnimationFrame;
}
@end

@implementation TransitionFromTableViewController
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FromVC";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = (TransitionNavigationViewController *)self.navigationController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [BBPhoneVideoTransition new];
}


#pragma mark - BBPhoneToVideoTransitionProtocol

- (CGRect)toVideoTransitionAnimationViewFrame
{
    return _transitionAnimationFrame;
}

- (CGRect)toVideoTransitionViewControllerFrame
{
    return [UIScreen mainScreen].bounds;
}

- (void)toVideoTransitionCompelete:(UIView *)animationView
{
    if (_cell) {
        [_cell addPlayer:animationView];
    }
}

#pragma mark - BBPhoneFromVideoTransitionProtocol

- (CGRect)fromVideoTransitionAnimationViewFrame
{
    return _transitionAnimationFrame;
}

- (UIView *)fromVideoTransitionAnimationView
{
    return _transitionAnimationView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransitionCell *cell = [[TransitionCell alloc] initWithFrame:CGRectZero];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransitionCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    _transitionAnimationView = cell.playerView;
    _cell = cell;
    UIWindow* desWindow=[UIApplication sharedApplication].keyWindow;
    CGRect frame = [_transitionAnimationView convertRect:_transitionAnimationView.bounds toView:desWindow];
    _transitionAnimationFrame = frame;
    
    TransitionToTableViewController * toVC = [[TransitionToTableViewController alloc] init];
    [self.navigationController pushViewController:toVC animated:YES];
    
}


@end
