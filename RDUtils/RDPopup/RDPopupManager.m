//
//  RDPopupManager.m
//  Quem Quer Dinheiro
//
//  Created by iMac on 07/05/15.
//  Copyright (c) 2015 WalkMe Mobile Solutions. All rights reserved.
//

#import "RDPopupManager.h"
#import "AppDelegate.h"

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
    
    UIViewController *rootVC = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) visibleViewController:[[[UIApplication sharedApplication] delegate].window rootViewController]];
    
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
@end

