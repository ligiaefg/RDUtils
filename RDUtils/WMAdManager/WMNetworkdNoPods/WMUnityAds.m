//
//  WMUnityAds.m
//  RDUtils
//
//  Created by iMac on 13/05/15.
//  
//

#import "WMUnityAds.h"
#import <UnityAds/UnityAds.h>

@interface WMUnityAds () <UnityAdsDelegate>{

}
@property (weak, nonatomic) id<RewardVideoDelegate> rewardVideoDelegate;
@property (strong, nonatomic) NSDictionary * zones;
@end

@implementation WMUnityAds
- (void)startUnityWithGameID:(NSString *)gameID andZonesIds:(NSDictionary *)zones{
    // Initialize Unity Ads
    [[UnityAds sharedInstance] startWithGameId:gameID];
#ifdef DEBUG
    [[UnityAds sharedInstance] setTestMode:YES];
#endif
    _zones = zones;
    [UnityAds sharedInstance].delegate = self;
}

- (BOOL)showRewardVideoWithDelegate:(id<RewardVideoDelegate>)delegate onViewController:(UIViewController*)vc withZone:(WMAdsZones)zone{
    if ([[UnityAds sharedInstance] canShowAds])
    {
        [[UnityAds sharedInstance] setViewController:vc];
        [[UnityAds sharedInstance] setZone:[_zones objectForKey:@(zone)] ? [_zones objectForKey:@(zone)] : @""];
        self.rewardVideoDelegate = delegate;
         [super event:WMAdsAnaliticsShow andDescription:nil];
        [[UnityAds sharedInstance] show];
        return YES;
    }
    return NO;
}

-(BOOL)checkRewardVideoForZone:(WMAdsZones)zone{
    [[UnityAds sharedInstance] setZone:[_zones objectForKey:@(zone)] ? [_zones objectForKey:@(zone)] : @""];
    BOOL hasVideo = [[UnityAds sharedInstance] canShowAds];
    if (!hasVideo) {
        [super event:WMAdsAnaliticsError andDescription:@"No Ads"];
    }
    return hasVideo;
}

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped{
    //AD was completed
    //Give user the credits
    
    [self.rewardVideoDelegate rewardVideoGiveRewardWithSuccess:!skipped];
#ifdef DEBUG
    NSLog(@"Ended Video");
#endif
}

- (void)unityAdsVideoStarted{
    [self.rewardVideoDelegate videoDidShow];
}

- (void)unityAdsDidHide{
    //AD was closed.
    //Perform complete animations
    [self.rewardVideoDelegate videoDidHide];
}

- (void)unityAdsFetchFailed{
    [super event:WMAdsAnaliticsError andDescription:@"Fail"];
}

- (void)unityAdsWillLeaveApplication{
    [super event:WMAdsAnaliticsClick andDescription:nil];
}
@end
