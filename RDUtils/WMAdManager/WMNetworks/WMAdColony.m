//
//  WMAdColony.m
//  RDUtils
//
//  Created by iMac on 13/05/15.
//
//

#import "WMAdColony.h"
#import <AdColony/AdColony.h>


@interface WMAdColony () <AdColonyAdDelegate, AdColonyDelegate>{
    NSDictionary *adColonyZoneIDs;
    NSMutableDictionary *hasAdColonyVideo;
}
@property (weak, nonatomic) id<RewardVideoDelegate> rewardVideoDelegate;

@end

@implementation WMAdColony
- (void)startAdcolonyWithKey:(NSString *)key andZoneIds:(NSDictionary *)zoneIds{
    [AdColony configureWithAppID:key zoneIDs:[zoneIds allValues] delegate:self logging:YES];
    adColonyZoneIDs = zoneIds;
    hasAdColonyVideo = [[NSMutableDictionary alloc] init];
}


- (BOOL)showRewardVideoWithDelegate:(id<RewardVideoDelegate>)delegate onViewController:(UIViewController*)vc withZone:(WMAdsZones)zone{
    [super event:WMAdsAnaliticsShow andDescription:nil];
    [AdColony playVideoAdForZone:[adColonyZoneIDs objectForKey:@(zone)] withDelegate:self withV4VCPrePopup:NO andV4VCPostPopup:NO];
    self.rewardVideoDelegate = delegate;
    return YES;
}


- (BOOL)checkRewardVideoForZone:(WMAdsZones)zone{
    if (![[hasAdColonyVideo objectForKey:@(zone)] boolValue]) {
        [super event:WMAdsAnaliticsError andDescription:@"No Ads"];
    }
    return [[hasAdColonyVideo objectForKey:@(zone)] boolValue];
}



-(void)onAdColonyAdStartedInZone:(NSString *)zoneID{
    [self.rewardVideoDelegate videoDidShow];
}


-(void)onAdColonyAdFinishedWithInfo:(AdColonyAdInfo *)info{
    //AD was closed.
    //Perform complete animations
    [self.rewardVideoDelegate videoDidHide];
}

-(void)onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID{
    
}




#pragma mark -
#pragma mark AdColony V4VC

// Callback activated when a V4VC currency reward succeeds or fails
// This implementation is designed for client-side virtual currency without a server
// It uses NSUserDefaults for persistent client-side storage of the currency balance
// For applications with a server, contact the server to retrieve an updated currency balance
// On success, posts an NSNotification so the rest of the app can update the UI
// On failure, posts an NSNotification so the rest of the app can disable V4VC UI elements
- ( void ) onAdColonyV4VCReward:(BOOL)success currencyName:(NSString*)currencyName currencyAmount:(int)amount inZone:(NSString*)zoneID {
    NSLog(@"AdColony zone %@ reward %i %i %@", zoneID, success, amount, currencyName);
    
 
    [self.rewardVideoDelegate rewardVideoGiveRewardWithSuccess:success];
 

}

#pragma mark -
#pragma mark AdColony ad fill

- ( void ) onAdColonyAdAvailabilityChange:(BOOL)available inZone:(NSString*) zoneID {
    NSArray * keys = [adColonyZoneIDs allKeysForObject:zoneID];
    if(available) {
        [hasAdColonyVideo setObject:@(YES) forKey:[keys count] ? [keys objectAtIndex:0] : @(-1)];
        //[[NSNotificationCenter defaultCenter] postNotificationName:kZoneReady object:nil];
    } else {
        [hasAdColonyVideo setObject:@(NO) forKey:[keys count] ? [keys objectAtIndex:0] : @(-1)];
        // [[NSNotificationCenter defaultCenter] postNotificationName:kZoneLoading object:nil];
    }
}

@end
