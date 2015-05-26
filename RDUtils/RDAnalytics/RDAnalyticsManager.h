//
//  RDAnalyticsManager.h
//  RDUtils
//
//  Created by iMac on 20/04/15.
//

#import <Foundation/Foundation.h>

@interface RDAnalyticsManager : NSObject

/**
 *  Inits the Analitics Manager
 *
 *  @return Manager Instance
 */
+ (RDAnalyticsManager *)sharedManager;

/**
 *  Starts traking
 *
 *  @param gadKey    GoogleAnaliticsKey
 *  @param flurryKey FlurryKey
 */
- (void)startTrakingWithGAD:(NSString*)gadKey andFlurry:(NSString*)flurryKey;

/**
 *  Starts traking
 *
 *  @param gadKey     GoogleAnaliticsKey
 *  @param flurryKey  FlurryKey
 *  @param extraInit  Block where any extra analitics should be initialized
 *  @param extraEvent Block that is called to send events to any extra analitcs
 */
- (void)startTrakingWithGAD:(NSString*)gadKey andFlurry:(NSString*)flurryKey andExtraInit:(void(^)())extraInit andExtraEvent:(void(^)(NSString*category, NSString*action, NSString*label))extraEvent;

/**
 *  Send a event with category and action
 *
 *  @param category Event category
 */
- (void)sendEvent:(NSString*)category;

/**
 *  Send a event with category and action
 *
 *  @param category Event category
 *  @param action   Event action
 */
- (void)sendEvent:(NSString*)category Action:(NSString*)action;

/**
 *  Send and event with category, action and label
 *
 *  @param category Event category
 *  @param action   Event action
 *  @param label    Event description
 */
- (void)sendEvent:(NSString*)category Action:(NSString*)action Label:(NSString*)label;

@end
