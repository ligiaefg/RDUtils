//
//  WMAdManager.h
//  RDUtils
//
//  Created by iMac on 13/05/15.
//  
//

#import <Foundation/Foundation.h>


@protocol RewardVideoDelegate<NSObject>

@required

/**
 *  Give the desired reward to the user
 *
 *  @param success operation result
 */
- (void)rewardVideoGiveRewardWithSuccess:(BOOL)success;

/**
 *  is called onde the ad has disapered. Use to restar sound or any animations that should be present after the video
 */
- (void)videoDidHide;

/**
 * Called when video start
 */
- (void)videoDidShow;
@end


@protocol FullScreenAdDelegate<NSObject>

@required

- (void)adDidHide;

- (void)adDidShow;

@end

/**
 *  WM Ads Zones
 */
typedef NS_ENUM(NSInteger, WMAdsZones){
    /**
     *  Default ad zone
     */
    WMAdsZoneDefault,
    /**
     *  home ad zone
     */
    WMAdsZoneHome
};


@interface WMAdManager : NSObject
+ (WMAdManager *)sharedManager;

/**
 *  Premium users dont have full screen and banner ads
 */
@property (nonatomic) BOOL isPremium;

/**
 *  TODO Set the manager to automaticly load the next ad
 */
@property (nonatomic) BOOL fullScreenAutomaticMode;

/**
 *  Load the ad in a random order. As default this is disabled
 */
@property (nonatomic) BOOL fullScreenRandomOrder;

/**
 *  An array with the networks from where the ads will be loaded.
 *  This will also be the order in which the networks will appear. 
 *  If you want one network to appear multiple times in a row (ex: A -> A -> B -> C) just ad it multiple times tot he array
 */
@property (strong, nonatomic) NSArray *fullScreenNetworks;

/**
 *  Load the reward videos in a random order. As default this is disabled
 */
@property (nonatomic) BOOL rewardVideosRandomOrder;

/**
 *  An array with the networks from were video the will be loaded.
 *  This will also be the order in which the networks will appear.
 *  If you want one network to appear multiple times in a row (ex: A -> A -> B -> C) just ad it multiple times tot he array
 */
@property (strong, nonatomic) NSArray *rewardVideosNetworks;

/**
 *  Load a fullscreen ad
 *
 *  @return success
 */
- (BOOL)loadFullScreenAdsForZone:(WMAdsZones)zone;

/**
 *  Prsent the full screeen ad
 *
 *  @param delegate callback methods
 *  @param vc       view controller where the ad will be presented
 *  @param zone     Ad Zone
 *
 *  @return if the operation was successeful
 */
- (BOOL)showFullScreenAdsWithDelegate:(id<FullScreenAdDelegate>)delegate onViewController:(UIViewController*)vc andZone:(WMAdsZones)zone;

/**
 *  This is called by the networks when they fail to load ad
 *
 *  @param zone Ad Zone
 */
- (void)loadAnotherFullScreenNetworkForZone:(WMAdsZones)zone;

- (BOOL)checkRewardVideoForZone:(WMAdsZones)zone;
- (BOOL)showRewardVideoWithDelegate:(id<RewardVideoDelegate>)delegate onViewController:(UIViewController*)vc andZone:(WMAdsZones)zone;
@end
