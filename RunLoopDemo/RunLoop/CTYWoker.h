//
//  CTYWoker.h
//  RunLoopDemo
//
//  Created by cotin on 15/01/2018.
//  Copyright © 2018 cotin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTYWoker : NSObject

-(void)start;

- (void)addDataForSource;

- (void)pingSource;

- (void)invalidateSource;

@end
