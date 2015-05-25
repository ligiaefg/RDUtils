//
//  WMUnityAds.h
//  RDUtils
//
//  Created by iMac on 13/05/15.
//  
//

#import <Foundation/Foundation.h>
#import "WMSuperAd.h"

@interface WMUnityAds : WMSuperAd
- (void)startUnityWithGameID:(NSString *)gameID andZonesIds:(NSDictionary *)zones;

@end
