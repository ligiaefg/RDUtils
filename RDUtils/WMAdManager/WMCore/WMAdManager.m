//
//  WMAdManager.m
//  RDUtils
//
//  Created by iMac on 13/05/15.
//
//

#import "WMAdManager.h"
#import "TestConnection.h"
#import "Reachability.h"
#import "WMSuperAd.h"
#import "RDAnalyticsManager.h"

@interface WMAdManager (){
    Reachability *reachability;
    BOOL awaytingNetworkChange;
    BOOL isWaytingFullScreen;
    NSInteger fullScreenCount;
    NSInteger rewardVideoCount;
    WMSuperAd *currentFullScreenAd;
    WMSuperAd *currentRewardVideoAd;
    NSMutableArray *fullScreenErrors;
}

@end
@implementation WMAdManager


+ (WMAdManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static WMAdManager *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (int)randomNumberTo:(int)max{
    return arc4random_uniform(max);
}

#pragma mark -
#pragma mark - Full Screen Ads
- (BOOL)loadFullScreenAdsForZone:(WMAdsZones)zone{
    /*int pos = 0;
     if(!self.fullScreenOrder || !self.fullScreenOrder.count){
     pos = [self randomNumberTo:[self.fullScreenNetworks count]];
     }else{
     pos = fullScreenCount % [self.fullScreenOrder count];
     if (pos >= self.fullScreenOrder.count) {
     pos = 0;
     }
     pos = [[self.fullScreenOrder objectAtIndex:pos] intValue];
     if (pos >= self.fullScreenNetworks.count) {
     pos = 0;
     }
     }*/
    if (self.isPremium) {
        return YES;
    }
    
    return [self loadFullScreenAdsAtPossition:self.fullScreenRandomOrder ? [self randomNumberTo:(int)[self.fullScreenNetworks count]] : (int)fullScreenCount % (int)[self.fullScreenNetworks count] andZone:zone];
}


- (BOOL)loadFullScreenAdsAtPossition:(int)possition andZone:(WMAdsZones)zone{
    if ([TestConnection test]) {
        currentFullScreenAd = [self.fullScreenNetworks objectAtIndex:possition];
        return [currentFullScreenAd  loadFullScreenAdsForZone:zone];
    }else{
        isWaytingFullScreen = YES;
        [self startNetworkObserver];
    }
    return NO;
}

- (BOOL)showFullScreenAdsWithDelegate:(id<FullScreenAdDelegate>)delegate onViewController:(UIViewController*)vc andZone:(WMAdsZones)zone{
    
    if (self.isPremium) {
        return YES;
    }
    isWaytingFullScreen = NO;
    fullScreenCount++;
    fullScreenErrors = [[NSMutableArray alloc] init];
    return  [currentFullScreenAd showFullScreenAdsWithDelegate:delegate onViewController:vc withZone:zone];
}

#pragma mark - Full Screen Errors
- (void)loadAnotherFullScreenNetworkForZone:(WMAdsZones)zone{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!fullScreenErrors) {
            fullScreenErrors = [[NSMutableArray alloc] init];
        }
        [fullScreenErrors addObject:currentFullScreenAd];
        
        for (int i = 0; i < self.fullScreenNetworks.count; i++) {
            fullScreenCount++;
            currentFullScreenAd = [self.fullScreenNetworks objectAtIndex:fullScreenCount % [self.fullScreenNetworks count]];
            if (![fullScreenErrors containsObject:currentFullScreenAd]) {
                [self loadFullScreenAdsAtPossition:(int)fullScreenCount % (int)[self.fullScreenNetworks count] andZone:zone];
                break;
            }
        }
        
        if (fullScreenErrors.count == self.fullScreenNetworks.count) {
            [[RDAnalyticsManager sharedManager] sendEvent:@"ADS" Action:@"All Network Fail" Label:@""];
        }
    });
}

#pragma mark -
#pragma mark - Reward Videos
- (BOOL)checkRewardVideoForZone:(WMAdsZones)zone{
    
    BOOL hasVideo = [self checkRewardVideoAtPossition:self.rewardVideosRandomOrder ? [self randomNumberTo:(int)[self.rewardVideosNetworks count]] : (int)rewardVideoCount % (int)self.rewardVideosNetworks.count andZone:zone];
    if (!hasVideo) {
        NSInteger localPossition = rewardVideoCount;
        do {
            hasVideo = [self checkRewardVideoAtPossition:((int)rewardVideoCount % (int)self.rewardVideosNetworks.count) andZone:zone];
            if (hasVideo) {
                break;
            }else{
                rewardVideoCount++;
            }
        } while (localPossition % self.rewardVideosNetworks.count != rewardVideoCount % self.rewardVideosNetworks.count);
    }
    
    if (!hasVideo) {
        [[RDAnalyticsManager sharedManager] sendEvent:@"ADS" Action:@"User click, but no reward videos"];
    }
    
    return hasVideo;
    
}

- (BOOL)showRewardVideoWithDelegate:(id<RewardVideoDelegate>)delegate onViewController:(UIViewController*)vc andZone:(WMAdsZones)zone{
    rewardVideoCount++;
    return  [currentRewardVideoAd showRewardVideoWithDelegate:delegate onViewController:vc withZone:zone];
}

- (BOOL)checkRewardVideoAtPossition:(int)possition andZone:(WMAdsZones)zone{
    currentRewardVideoAd = [self.rewardVideosNetworks objectAtIndex:possition];
    return [currentRewardVideoAd checkRewardVideoForZone:zone];
}

#pragma mark -
#pragma mark - Network change observer
- (void)startNetworkObserver{
    if (!reachability) {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleNetworkChange) name: kReachabilityChangedNotification object: nil];
        reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
    }
    awaytingNetworkChange = YES;
}

- (void)handleNetworkChange{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (awaytingNetworkChange) {
            awaytingNetworkChange = NO;
            if (self.fullScreenAutomaticMode || isWaytingFullScreen) {
                [self loadFullScreenAdsForZone:WMAdsZoneHome];
            }
        }
    });
}
@end
