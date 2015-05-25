//
//  UIView+Constraints.h
//  NameThatPic
//
//  Created by iMac on 22/04/15.
//  Copyright (c) 2015 b7dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Constraints)
/* Margin. */

struct CGMargin {
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
};
typedef struct CGPoint CGMargin;

-(void)matchParent;
@end
