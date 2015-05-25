//
//  UIView+Constraints.m
//  NameThatPic
//
//  Created by iMac on 22/04/15.
//  Copyright (c) 2015 b7dev. All rights reserved.
//

#import "UIView+Constraints.h"

@implementation UIView (Constraints)
-(void)matchParent{
    if ([self superview]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:[self superview]
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0]];
        
        [[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:[self superview]
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:0]];
        
        [[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:[self superview]
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1
                                                                      constant:0]];
        
        [[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:[self superview]
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1
                                                                      constant:0]];

    }else{
        NSLog(@"UIView+Constraints - Suplied view does not have a superview to match");
    }
}




@end
