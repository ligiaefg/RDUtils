//
//  WMAdMob.m
//  RDUtils
//
//  Created by iMac on 13/05/15.
//  
//

#import "WMAdMob.h"
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface WMAdMob () <GADInterstitialDelegate>{
    //GADInterstitial *interstitial_;
    //NSString *interstitialKey;
    NSMutableDictionary *interstitialKeys;
    NSMutableDictionary *interstitials;
    BOOL isInitialized;
}
@property (weak, nonatomic) id<FullScreenAdDelegate> hideDelegate;

@end

@implementation WMAdMob

- (void)startFullScreenNetworkWithKey:(NSArray *)keys andZones:(NSArray *)zones{
    interstitialKeys = [[NSMutableDictionary alloc] init];
    interstitials = [[NSMutableDictionary alloc] init];
    for (int i = 0 ; i < keys.count ; i++) {
        [interstitialKeys setObject:[keys objectAtIndex:i] forKey:[zones objectAtIndex:i]];
    }
    isInitialized = YES;
}

#pragma mark - Google Ads
- (BOOL)showFullScreenAdsWithDelegate:(id<FullScreenAdDelegate>)delegate  onViewController:(UIViewController*)vc withZone:(WMAdsZones)zone{
    if (!isInitialized) {
        NSLog(@"ERROR - Interstitial Not Loaded");
        return NO;
    }
    GADInterstitial *interstitial = [interstitials objectForKey:@(zone)];
    if([interstitial isReady])
    {
        @try
        {
            [interstitial presentFromRootViewController:vc];
            [super event:WMAdsAnaliticsShow andDescription:nil];
            self.hideDelegate = delegate;
            return YES;
        }
        @catch(NSException *exception){
            [super event:WMAdsAnaliticsError andDescription:[NSString stringWithFormat:@"%@",[exception reason]]];
        }
    }
    return NO;
}


- (BOOL)loadFullScreenAdsForZone:(WMAdsZones)zone{
    [super loadFullScreenAdsForZone:zone];
    
    if (!isInitialized) {
        NSLog(@"ERROR - Interstitial Not Loaded");
        return NO;
    }
    
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:[interstitialKeys objectForKey:@(zone)]];
    interstitial.delegate = self;
    //interstitial_.adUnitID = GOOGLE_ADS_ID;
    GADRequest  *request =[GADRequest request];
    request.testDevices = TEST_DEVICES;
    [interstitial loadRequest:request];
    [interstitials setObject:interstitial forKey:@(zone)];
    [super event:WMAdsAnaliticsLoad andDescription:nil];
    return YES;
    
}



#pragma mark -
#pragma mark - Google Ads Delegate
-(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    if (self.hideDelegate) {
        [self.hideDelegate adDidHide];
        self.hideDelegate = nil;
    }
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSString *errorName;
    switch (error.code) {
        case kGADErrorInvalidRequest:
            errorName = @"kGADErrorInvalidRequest";
            break;
        case kGADErrorNoFill:
            errorName = @"kGADErrorNoFill";
            break;
        case kGADErrorServerError:
            errorName = @"kGADErrorServerError";
            break;
        case kGADErrorOSVersionTooLow:
            errorName = @"kGADErrorOSVersionTooLow";
            break;
        case kGADErrorInterstitialAlreadyUsed:
            errorName = @"kGADErrorInterstitialAlreadyUsed";
            break;
        case kGADErrorMediationDataError:
            errorName = @"kGADErrorMediationDataError";
            break;
        case kGADErrorMediationAdapterError:
            errorName = @"kGADErrorMediationAdapterError";
            break;
        case kGADErrorMediationNoFill:
            errorName = @"kGADErrorMediationNoFill";
            break;
        case kGADErrorMediationInvalidAdSize:
            errorName = @"kGADErrorMediationInvalidAdSize";
            break;
        case kGADErrorInternalError:
            errorName = @"kGADErrorInternalError";
            break;
        case kGADErrorInvalidArgument:
            errorName = @"kGADErrorInvalidArgument";
            break;
        case kGADErrorReceivedInvalidResponse:
            errorName = @"kGADErrorReceivedInvalidResponse";
            break;
        default:
            errorName = @"Unknown";
            break;
    }
    
    [super event:WMAdsAnaliticsError andDescription:[NSString stringWithFormat:@"Error: %@", errorName]];
    NSArray * keys = [interstitialKeys allKeysForObject:ad];
    [[WMAdManager sharedManager] loadAnotherFullScreenNetworkForZone:keys.count ? [[keys objectAtIndex:0] integerValue] : WMAdsZoneDefault];
}

-(void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    [super event:WMAdsAnaliticsClick andDescription:nil];
}


-(void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    if (self.hideDelegate) {
        [self.hideDelegate adDidShow];
    }
}

@end
