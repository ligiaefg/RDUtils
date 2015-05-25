//
//  RDPopupViewController.h
//  RDUtils
//
//  Created by Rob on 12/07/13.
//  Copyright (c) 2013 Rob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RDPopupManagerDelegate;
@interface RDPopupViewController : UIViewController
@property (weak, nonatomic)id<RDPopupManagerDelegate>delegate;
- (void)closePopup;
- (void)closePopUpWith:(id)data;
@end

@protocol RDPopupManagerDelegate<NSObject>
@optional

- (void)popupDidDissapearWith:(id)data;
- (void)popUpDidAppear;
@end