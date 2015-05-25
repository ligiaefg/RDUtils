//
//  RDPopupManager.h
//  Quem Quer Dinheiro
//
//  Created by iMac on 07/05/15.
//  Copyright (c) 2015 WalkMe Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPopupViewController.h"

typedef NS_ENUM(NSInteger, RDPopupAnimations) {
    RDPopupAnimationFade
};

@interface RDPopupManager : NSObject
+ (void)presentPopUp:(RDPopupViewController*)vc WithAnimation:(RDPopupAnimations)aniamation andDelegate:(id<RDPopupManagerDelegate>)delegate;
@end


