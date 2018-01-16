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

void CTYWokerRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSString *activityStr = @"";
    switch (activity) {
        case kCFRunLoopEntry:
            activityStr = @"entry";
            break;
        case kCFRunLoopBeforeTimers:
            activityStr = @"before timers";
            break;
        case kCFRunLoopBeforeSources:
            activityStr = @"before sources";
            break;
        case kCFRunLoopBeforeWaiting:
            activityStr = @"before waiting";
            break;
        case kCFRunLoopAfterWaiting:
            activityStr = @"after waiting";
            break;
        case kCFRunLoopExit:
            activityStr = @"exit";
            break;
        default:
            break;
    }
//    NSLog(@"run loop activity:%@", activityStr);
}


- (void) addRunLoopObserver{
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    // Create a run loop observer and attach it to the run loop.
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                               kCFRunLoopAllActivities, YES, 0, &CTYWokerRunLoopObserverCallBack, &context);
    
    if (observer)
    {
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
}

- (void)start {
    [_worker start];
}

- (void) workerThread: (id) data
{
    NSLog(@"Enter worker thread");
    // add run loop observer
    [self addRunLoopObserver];
    
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
        // sources or timers,go ahead and exit.
        if ((result == kCFRunLoopRunStopped) || result == kCFRunLoopRunFinished)
            done = YES;
//        NSLog(@"before woker sleeping");
//        [NSThread sleepForTimeInterval:20];
//        NSLog(@"after woker sleeping");
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
- (void)invalidateSource{
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
