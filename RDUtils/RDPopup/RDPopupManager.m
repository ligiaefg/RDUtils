//
//  RDPopupManager.m
//  RDUtils
//
//  Created by Rob on 12/07/13.
//  Copyright (c) 2013 Rob. All rights reserved.
//

#import "RDPopupManager.h"

@implementation RDPopupManager
+ (void)presentPopUp:(RDPopupViewController*)vc WithAnimation:(RDPopupAnimations)aniamation andDelegate:(id<RDPopupManagerDelegate>)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (aniamation) {
            case RDPopupAnimationFade:
                [RDPopupManager presentFadePopUp:vc andDelegate:delegate];
                break;
                
            default:
                break;
        }
    });
    
}

+ (void)presentFadePopUp:(RDPopupViewController*)vc andDelegate:(id<RDPopupManagerDelegate>)delegate{
    
    UIViewController *rootVC = [RDPopupManager visibleViewController:[[[UIApplication sharedApplication] delegate].window rootViewController]];
    
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController*)rootVC;
        rootVC = navVC.visibleViewController;
    }
    
    [rootVC addChildViewController:vc];
    [rootVC.view addSubview:vc.view];
    vc.view.translatesAutoresizingMaskIntoConstraints = NO;
    [rootVC.view addConstraint:[NSLayoutConstraint constraintWithItem:vc.view
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:rootVC.view
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0]];
    
    [rootVC.view addConstraint:[NSLayoutConstraint constraintWithItem:vc.view
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:rootVC.view
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:0]];
    
    [rootVC.view addConstraint:[NSLayoutConstraint constraintWithItem:vc.view
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:rootVC.view
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1
                                                             constant:0]];
    
    [rootVC.view addConstraint:[NSLayoutConstraint constraintWithItem:vc.view
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:rootVC.view
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1
                                                             constant:0]];
    vc.view.alpha = 0;
    vc.delegate = delegate;
    [UIView animateWithDuration:.6f animations:^{
        vc.view.alpha = 1;
    } completion:^(BOOL finished) {
        if (delegate && [delegate respondsToSelector:@selector(popUpDidAppear)]) {
            [delegate popUpDidAppear];
        }
    }];
    
}


+ (UIViewController *)visibleViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil)
    {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [RDPopupManager visibleViewController:lastViewController];
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController.presentedViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;
        
        return [RDPopupManager visibleViewController:selectedViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    
    return [RDPopupManager visibleViewController:presentedViewController];
}
@end

