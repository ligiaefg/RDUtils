//
//  WMSuperAd.m
//  RDUtils
//
//  Created by iMac on 13/05/15.
//  
//

#import "WMSuperAd.h"
#import "RDAnalyticsManager.h"
@implementation WMSuperAd
static  NSMutableDictionary* networks;
+ (WMSuperAd *)sharedNetwork
{
    if (!networks) {
        networks = [[NSMutableDictionary alloc] init];
    }
    
    NSString * className = NSStringFromClass([self class]);
    
    WMSuperAd *adNetwork = [networks objectForKey:className];
    if (!adNetwork) {
        adNetwork = [[self alloc] init];
        [networks setObject:adNetwork forKey:className];
    }
    
    return adNetwork;
}


- (void)event:(WMAdsAnaliticsNotifications)label andDescription:(NSString*)description{
    NSString * labelString;
    switch (label) {
        case WMAdsAnaliticsLoad:
            labelString = @"Load";
            break;
        case WMAdsAnaliticsShow:
            labelString = @"Show";
            break;
        case WMAdsAnaliticsClick:
            labelString = @"Click";
            break;
        case WMAdsAnaliticsError:
            labelString = @"Error";
            break;
        default:
            labelString = @"Unknown";
            break;
    }
    
    if (description) {
        labelString = [NSString stringWithFormat:@"%@: %@", labelString, description];
    }
    
    [[RDAnalyticsManager sharedManager] sendEvent:@"ADS" Action:NSStringFromClass([self class]) Label:labelString];

}

- (BOOL)loadFullScreenAdsForZone:(WMAdsZones)zone{
    return YES;
}

- (BOOL)showFullScreenAdsWithDelegate:(id<FullScreenAdDelegate>)delegate  onViewController:(UIViewController*)vc withZone:(WMAdsZones)zone{
    return YES;
}

- (BOOL)showRewardVideoWithDelegate:(id<RewardVideoDelegate>)delegate onViewController:(UIViewController*)vc withZone:(WMAdsZones)zone{
    return YES;
}

- (BOOL)checkRewardVideoForZone:(WMAdsZones)zone{
    return YES;
}

@end
