//
//  TransitionNavigationViewController.m
//  TransitionDemo
//
//  Created by Aries on 2018/7/5.
//  Copyright © 2018年 Aries. All rights reserved.
//

#import "TransitionNavigationViewController.h"
#import "BBPhoneVideoTransition.h"

@interface TransitionNavigationViewController ()

@end

@implementation TransitionNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return [BBPhoneVideoTransition new];
    } else if  (operation == UINavigationControllerOperationPush) {
        return [BBPhoneVideoTransition new];
    }
    return nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
