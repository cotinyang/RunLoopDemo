//
//  CTYWoker.m
//  RunLoopDemo
//
//  Created by cotin on 15/01/2018.
//  Copyright © 2018 cotin. All rights reserved.
//

#import "CTYWoker.h"
#import "CTYRunLoopSource.h"
#import "CTYRunLoopContext.h"

@interface CTYWoker()<CTYRunLoopSourceDelegate>

@property (nonatomic,strong) NSMutableArray *sourcesToPing;
@property (nonatomic,strong) NSThread *worker;

@end

@implementation CTYWoker

- (instancetype)init {
    self = [super init];
    if(self) {
        _sourcesToPing = [NSMutableArray array];
        _worker = [[NSThread alloc] initWithTarget:self
                                         selector:@selector(workerThread:)
                                           object:self];
    }
    return self;
}

- (void)start {
    [_worker start];
}

- (void) workerThread: (id) data
{
    NSLog(@"Enter worker thread");
    // Set up an autorelease pool here if not using garbage collection.
    BOOL done = NO;
    
    // Add your sources or timers to the run loop and do any other setup.
    CTYRunLoopSource* customRunLoopSource = [[CTYRunLoopSource alloc] init];
    customRunLoopSource.delegate = self;
    [customRunLoopSource addToCurrentRunLoop];
    
    do
    {
        // Start the run loop but return after each source is handled.
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 5, YES);
        
        // If a source explicitly stopped the run loop, or if there are no
        // sources or timers, or our runloopSource is invalid ->
        // go ahead and exit.
        if ((result == kCFRunLoopRunStopped) || result == kCFRunLoopRunFinished)
            done = YES;
    }
    while (!done);
    
    // Clean up code here. Be sure to release any allocated autorelease pools.
    NSLog(@"Exit worker thread");
}

- (void)pingSource{
    if (self.sourcesToPing.count) {
        CTYRunLoopContext* sourceCtx = self.sourcesToPing[0];
        [sourceCtx.source fireAllCommandsOnRunLoop:sourceCtx.runLoop];
    }
}
- (void)stopSource{
    if (self.sourcesToPing.count) {
        CTYRunLoopContext* sourceCtx = self.sourcesToPing[0];
        [sourceCtx.source invalidate];
    }
}

#pragma mark - CTYRunLoopSourceDelegate
- (void)runLoopSourceScheduled:(CTYRunLoopContext *)context {
    [self.sourcesToPing addObject:context];
}

- (void)runLoopSourceCanceled:(CTYRunLoopContext *)context {
    id objToRemove = nil;
    
    for (CTYRunLoopContext *ctx in self.sourcesToPing)
    {
        if ([ctx isEqual:context])
        {
            objToRemove = ctx;
            break;
        }
    }
    if (objToRemove)
        [self.sourcesToPing removeObject:objToRemove];
}


@end
