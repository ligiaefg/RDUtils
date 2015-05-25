//
//  WMAdMob.h
//  RDUtils
//
//  Created by iMac on 13/05/15.
//  
//

#import <Foundation/Foundation.h>
#import "WMSuperAd.h"

@interface WMAdMob : WMSuperAd
- (void)startFullScreenNetworkWithKey:(NSArray *)keys andZones:(NSArray *)zones;
@end
