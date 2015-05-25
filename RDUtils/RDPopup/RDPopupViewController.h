//
//  RDPopupViewController.h
//  Quem Quer Dinheiro
//
//  Created by iMac on 07/05/15.
//  Copyright (c) 2015 WalkMe Mobile Solutions. All rights reserved.
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