//
//  WMCartboost.m
//  RDUtils
//
//  Created by iMac on 13/05/15.
//  
//

#import "WMChartboost.h"
#import <Chartboost/Chartboost.h>

@interface WMChartboost () <ChartboostDelegate>{
    BOOL isInitialized;
    
}
@property (weak, nonatomic) id<FullScreenAdDelegate> hideDelegate;

@end

@implementation WMChartboost

- (void)startCartboostWithAppId:(NSString *)appId andSignature:(NSString *)signature;{
    
    if (!appId || !signature) {
        NSLog(@"\n\n\n\n ERROR: MISSING CHARTBOOST SIG KEY \n\n\n\n");
        return;
    }
    isInitialized = YES;
    [Chartboost startWithAppId:appId
                  appSignature:signature
                      delegate:self];
    
    
}

#pragma mark - Google Ads
- (BOOL)showFullScreenAdsWithDelegate:(id<FullScreenAdDelegate>)delegate onViewController:(UIViewController*)vc withZone:(WMAdsZones)zone{
    if (!isInitialized) {
        NSLog(@"ERROR - Interstitial Not Loaded");
        return NO;
    }else if (![Chartboost hasInterstitial:[self getCBLocationForWMLocation:zone]]){
        [super event:WMAdsAnaliticsError andDescription:@"ChartBoostNoAd"];
        return NO;
    }
    
    @try
    {
        [Chartboost showInterstitial:[self getCBLocationForWMLocation:zone]];
        [super event:WMAdsAnaliticsShow andDescription:nil];
        self.hideDelegate = delegate;
        return YES;
    }
    @catch(NSException *exception){
        [super event:WMAdsAnaliticsError andDescription:[NSString stringWithFormat:@"%@",[exception reason]]];
    }
    
    return NO;
}


- (BOOL)loadFullScreenAdsForZone:(WMAdsZones)zone{
    [super loadFullScreenAdsForZone:zone];
    
    if (!isInitialized) {
        NSLog(@"ERROR - Interstitial Not Loaded");
        return NO;
    }
    
    [Chartboost cacheInterstitial:[self getCBLocationForWMLocation:zone]];
    [super event:WMAdsAnaliticsLoad andDescription:nil];
    return YES;
    
}

#pragma mark -
#pragma mark - Chartboost Delegate

- (void)didDismissInterstitial:(CBLocation)location{
    if (self.hideDelegate) {
        [self.hideDelegate adDidHide];
    }
}

- (void)didClickInterstitial:(CBLocation)location{
    [super event:WMAdsAnaliticsClick andDescription:nil];
}

- (void)didFailToLoadInterstitial:(CBLocation)location
                        withError:(CBLoadError)error{
    
    NSString * stringError;
    switch (error) {
        case CBLoadErrorInternal:
            stringError = @"Unknown internal error.";
            break;
        case CBLoadErrorInternetUnavailable:
            stringError = @"Network is currently unavailable.";
            break;
        case CBLoadErrorTooManyConnections:
            stringError = @"Too many requests are pending for that location.";
            break;
        case CBLoadErrorWrongOrientation:
            stringError = @"Interstitial loaded with wrong orientation";
            break;
        case CBLoadErrorFirstSessionInterstitialsDisabled:
            stringError = @"Interstitial disabled, first session.";
            break;
        case CBLoadErrorNetworkFailure:
            stringError = @"Network request failed.";
            break;
        case CBLoadErrorNoAdFound:
            stringError = @"No ad received.";
            break;
        case CBLoadErrorSessionNotStarted:
            stringError = @"Session not started.";
            break;
        case CBLoadErrorUserCancellation:
            stringError = @"User manually cancelled the impression.";
            break;
        case CBLoadErrorNoLocationFound:
            stringError = @"No location detected.";
            break;
        case CBLoadErrorPrefetchingIncomplete:
            stringError = @"Video Prefetching is not finished.";
            break;
        default:
            stringError = nil;
            break;
    }
    [super event:WMAdsAnaliticsError andDescription:stringError];
    [[WMAdManager sharedManager] loadAnotherFullScreenNetworkForZone:[self getWMLocationForCBLocation:location]];
}

- (void)didDisplayInterstitial:(CBLocation)location{
    if (self.hideDelegate) {
        [self.hideDelegate adDidShow];
    }
}

- (CBLocation)getCBLocationForWMLocation:(WMAdsZones)zone{
    switch (zone) {
        case WMAdsZoneDefault:
            return CBLocationDefault;
            break;
        case WMAdsZoneHome:
            return CBLocationHomeScreen;
            break;
            
        default:
            return CBLocationDefault;
            break;
    }
    
}


- (WMAdsZones)getWMLocationForCBLocation:(CBLocation)location{
    if ([location isEqualToString:CBLocationDefault]) {
        return WMAdsZoneDefault;
    }else if([location isEqualToString:CBLocationHomeScreen]) {
        return WMAdsZoneHome;
    }else{
        return WMAdsZoneDefault;
    }

}

@end
