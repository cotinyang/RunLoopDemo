//
//  CTYRunLoopContext.h
//  RunLoopDemo
//
//  Created by cotin on 15/01/2018.
//  Copyright © 2018 cotin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTYRunLoopSource;

@interface CTYRunLoopContext : NSObject

@property (readonly) CFRunLoopRef runLoop;
@property (readonly) CTYRunLoopSource *source;

- (id)initWithSource:(CTYRunLoopSource *)src andLoop:(CFRunLoopRef)loop;

@end
