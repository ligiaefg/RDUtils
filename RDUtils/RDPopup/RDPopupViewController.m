//
//  RDPopupViewController.m
//  Quem Quer Dinheiro
//
//  Created by iMac on 07/05/15.
//  Copyright (c) 2015 WalkMe Mobile Solutions. All rights reserved.
//

#import "RDPopupViewController.h"

@interface RDPopupViewController ()

@end

@implementation RDPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)closePopup{
    [self closePopupWithCompletion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(popupDidDissapearWith:)]) {
            [self.delegate popupDidDissapearWith:nil];
        }
    }];
}

- (void)closePopUpWith:(id)data{
    
    [self closePopupWithCompletion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(popupDidDissapearWith:)]) {
            [self.delegate popupDidDissapearWith:data];
        }
    }];
    
}

- (void)closePopupWithCompletion:(void(^)())completion{
    
    [UIView animateWithDuration:0.4f animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        completion();
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];

}

@end
