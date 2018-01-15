//
//  CTYRunLoopContext.m
//  RunLoopDemo
//
//  Created by cotin on 15/01/2018.
//  Copyright © 2018 cotin. All rights reserved.
//

#import "CTYRunLoopContext.h"
#import "CTYRunLoopSource.h"

@implementation CTYRunLoopContext

- (id)initWithSource:(CTYRunLoopSource*)src andLoop:(CFRunLoopRef)loop
{
    self = [super init];
    if (self) {
        _runLoop =  loop;
        _source = src;
        
    }
    return self;
}

@end
