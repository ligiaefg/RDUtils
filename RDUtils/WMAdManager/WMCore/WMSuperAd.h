//
//  WMSuperAd.h
//  RDUtils
//
//  Created by iMac on 13/05/15.
//  
//

#import <Foundation/Foundation.h>
#import "WMAdManager.h"
/**
 *  Analitics events
 */
typedef NS_ENUM(NSInteger, WMAdsAnaliticsNotifications){
    /**
     *  Ad has load event
     */
    WMAdsAnaliticsLoad,
    /**
     *  Ad was shown event
     */
    WMAdsAnaliticsShow,
    /**
     *  Ad was click event
     */
    WMAdsAnaliticsClick,
    /**
     *  Ad error event
     */
    WMAdsAnaliticsError,
};


#define TEST_DEVICES @[ @"85223c8a5f294b91ec4f8b602f670d0c", @"13747512fc4c63636eba1ab4d32f7660", @"470226ffd116110bb2ef466f1b04845a", @"46e9b1afb6121b99bd78474a9c4439e2", @"7fb59b02b48128ec5d9d65c2ecf26ccc"]

@interface WMSuperAd : NSObject
/**
 *  Creat the network
 *
 *  @return ad network
 */
+ (WMSuperAd *)sharedNetwork;

/**
 *  Send an ad related event to analitics. This should only be called only be used by the Networks.
 *
 *  @param label       Event type
 *  @param description Event description. Send NIL if none is desired.
 */
- (void)event:(WMAdsAnaliticsNotifications)label andDescription:(NSString*)description;

/**
 *  Load an AD to be shown later This should only be called only be used by the AdManager.
 *
 *  @param zone Zone of the add to be loaded
 *
 *  @return return if the call to load the AD was successefull. Does not take if account if the ad was loaded sucessfull
 */
- (BOOL)loadFullScreenAdsForZone:(WMAdsZones)zone;

/**
 *  Present the full screeen ad. This should only be called only be used by the AdManager.
 *
 *  @param delegate callback methods
 *  @param vc       view controller where the ad will be presented
 *  @param zone     Zone of the add to be shown
 *
 *  @return if the operation was succeseful
 */
- (BOOL)showFullScreenAdsWithDelegate:(id<FullScreenAdDelegate>)delegate  onViewController:(UIViewController*)vc withZone:(WMAdsZones)zone;

#pragma mark -
#pragma mark - Reward Videos

/**
 *  Present the reward video . This should only be called only be used by the AdManager.
 *
 *  @param delegate callback methods
 *  @param zone     Zone of the Reward Video
 *  @param vc       view controller where the ad will be presented
 *
 *  @return if the operation was succeseful
 */
- (BOOL)showRewardVideoWithDelegate:(id<RewardVideoDelegate>)delegate onViewController:(UIViewController*)vc withZone:(WMAdsZones)zone;

/**
 *  Check if this Network has any video availble to show
 *
 *  @return result
 */
- (BOOL)checkRewardVideoForZone:(WMAdsZones)zone;




@end
