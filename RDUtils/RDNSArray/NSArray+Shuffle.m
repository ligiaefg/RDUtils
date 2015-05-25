//
//  NSArray+Shuffle.m
//  NameThatPic
//
//  Created by ...dIeGo... on 8/8/14.
//  Copyright (c) 2014 b7dev. All rights reserved.
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
