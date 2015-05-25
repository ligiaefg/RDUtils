//
//  NSArray+Shuffle.m
//  RDUtils
//
//  Created by Rob on 12/07/13.
//  Copyright (c) 2013 Rob. All rights reserved.
//

#import "NSArray+Shuffle.h"

@implementation NSArray (Shuffle)

- (NSArray *)shuffle
{
	NSInteger count = (int)[self count];
    NSMutableArray *temp = [self mutableCopy];
   
    for (NSUInteger i = 0; i < count; ++i)
	{
        NSInteger elementsLeft = count - i;
        NSInteger n = (arc4random() % elementsLeft) + i;
        [temp exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return temp;
}

@end
