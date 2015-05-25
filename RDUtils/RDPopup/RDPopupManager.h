//
//  RDPopupManager.h
//  RDUtils
//
//  Created by Rob on 12/07/13.
//  Copyright (c) 2013 Rob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPopupViewController.h"

typedef NS_ENUM(NSInteger, RDPopupAnimations) {
    RDPopupAnimationFade
};

@interface RDPopupManager : NSObject
+ (void)presentPopUp:(RDPopupViewController*)vc WithAnimation:(RDPopupAnimations)aniamation andDelegate:(id<RDPopupManagerDelegate>)delegate;
@end


