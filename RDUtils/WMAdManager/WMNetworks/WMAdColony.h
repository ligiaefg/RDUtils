//
//  WMAdColony.h
//  RDUtils
//
//  Created by iMac on 13/05/15.
//  
//

#import <Foundation/Foundation.h>
#import "WMSuperAd.h"

@interface WMAdColony : WMSuperAd
- (void)startAdcolonyWithKey:(NSString *)key andZoneIds:(NSDictionary *)zoneIds;
@end
