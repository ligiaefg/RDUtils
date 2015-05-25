//
//  TestConnection.m
//
//
//  Created by Marco on 25/08/12.
//  
//

#import "TestConnection.h"
#import "Reachability.h"

@implementation TestConnection

+ (BOOL) test
{
    NSLog(@"Teste conexão iniciado");
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];
    return !(remoteHostStatus == NotReachable);
}

@end
