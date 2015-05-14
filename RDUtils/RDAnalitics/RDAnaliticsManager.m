//
//  AnaliticsManager.m
//  RDUtils
//
//  Created by iMac on 20/04/15.
//

#import "RDAnaliticsManager.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <FlurrySDK/Flurry.h>


@interface RDAnaliticsManager ()
@property (nonatomic, copy) void (^eventBlock)(NSString*category, NSString*action, NSString*label);
@end

@implementation RDAnaliticsManager

+ (RDAnaliticsManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static RDAnaliticsManager *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}

- (void)startTrakingWithGAD:(NSString*)gadKey andFlurry:(NSString*)flurryKey{
    [self startTrakingWithGAD:gadKey andFlurry:flurryKey andExtraInit:nil andExtraEvent:nil];
}

- (void)startTrakingWithGAD:(NSString*)gadKey andFlurry:(NSString*)flurryKey andExtraInit:(void(^)())extraInit andExtraEvent:(void(^)(NSString*category, NSString*action, NSString*label))extraEvent{
    
    static dispatch_once_t startOnceToken;

    dispatch_once(&startOnceToken, ^{
        //[Fabric with:@[CrashlyticsKit]];
        // Optional: automatically send uncaught exceptions to Google Analytics.
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 20;
        
        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:gadKey];
        
        // Instead, send a single hit with session control to start the new session.
        [tracker send:[[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                               action:@"appstart"
                                                                label:nil
                                                                value:nil] set:@"start" forKey:kGAISessionControl] build]];
        
        
        [Flurry setCrashReportingEnabled:NO];
        [Flurry startSession:flurryKey];
        
        if (extraInit) {
            extraInit();
        }
        
        self.eventBlock = extraEvent;
        
    });
    
}


- (void)sendEvent:(NSString*)category
{
    [self sendEvent:category Action:@""];
}
- (void)sendEvent:(NSString*)category Action:(NSString*)action
{
    [self sendEvent:category Action:action Label:@""];
}
- (void)sendEvent:(NSString*)category Action:(NSString*)action Label:(NSString*)label
{
    
    if(!category || [category  isEqualToString: @""]){return;}
    
    label = label ? label : @"-";
    action = action ? action : @"-";
    
    [Flurry logEvent:category withParameters:@{@"action" : action, @"label" : label}];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:[NSNumber numberWithInt:100]] build]];
    
    //CLSLog(@"Category:%@  Action:%@  Label:%@",category, action, label);
    if (self.eventBlock) {
        self.eventBlock(category, action, label);
    }
    
}
@end
