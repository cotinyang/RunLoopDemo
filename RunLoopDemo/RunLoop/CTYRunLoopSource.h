//
//  CTYRunLoopSource.h
//  RunLoopDemo
//
//  Created by cotin on 15/01/2018.
//  Copyright © 2018 cotin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CTYRunLoopContext;
@protocol CTYRunLoopSourceDelegate
@required
- (void)runLoopSourceScheduled:(CTYRunLoopContext *)context;
- (void)runLoopSourceCanceled:(CTYRunLoopContext *)context;
@end

@interface CTYRunLoopSource : NSObject {
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray *commands;
}

@property (nonatomic,weak) id<CTYRunLoopSourceDelegate> delegate;

- (id)init;
- (void)addToCurrentRunLoop;
- (void)invalidate;

// Handler method
- (void)sourceFired;

// Client interface for registering commands to process
- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;

@end
