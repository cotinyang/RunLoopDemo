//
//  CTYRunLoopSource.m
//  RunLoopDemo
//
//  Created by cotin on 15/01/2018.
//  Copyright © 2018 cotin. All rights reserved.
//

#import "CTYRunLoopSource.h"
#import "CTYRunLoopContext.h"
#import "AppDelegate.h"

void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    CTYRunLoopSource *obj = (__bridge CTYRunLoopSource *)info;
    CTYRunLoopContext *theContext = [[CTYRunLoopContext alloc] initWithSource:obj andLoop:rl];
    [obj.delegate runLoopSourceScheduled:theContext];
}

void RunLoopSourcePerformRoutine (void *info)
{
    CTYRunLoopSource *obj = (__bridge CTYRunLoopSource *)info;
    [obj sourceFired];
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    CTYRunLoopSource *obj = (__bridge CTYRunLoopSource *)info;
    CTYRunLoopContext* theContext = [[CTYRunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [obj.delegate runLoopSourceCanceled:theContext];

}

@implementation CTYRunLoopSource

- (id)init {
    CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
        &RunLoopSourceScheduleRoutine,
        RunLoopSourceCancelRoutine,
        RunLoopSourcePerformRoutine};
    
    runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    commands = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)addToCurrentRunLoop {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}

- (void)invalidate {
    
}

// Handler method
- (void)sourceFired {
    NSLog(@"Source fired handler called");
}

// Client interface for registering commands to process
- (void)addCommand:(NSInteger)command withData:(id)data {
    
}

- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop {
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}


@end
