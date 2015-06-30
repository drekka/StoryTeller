//
//  PerformanceTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 29/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import UIKit;
#import <XCTest/XCTest.h>
#import <StoryTeller/StoryTeller.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef LOG_ASYNC_ENABLED
#undef LOG_ASYNC_ENABLED
#endif
#define LOG_ASYNC_ENABLED NO

@interface PerformanceTests : XCTestCase

@end

@implementation PerformanceTests

static DDLogLevel ddLogLevel = DDLogLevelVerbose;

-(void) setUp {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

-(void) testFrameworks {

    ddLogLevel = DDLogLevelDebug;
    [[STStoryTeller storyTeller] reset];
    [STStoryTeller storyTeller].logger.showMethodDetails = NO;
    startLogging(@"[UIView].hidden == NO");

    NSArray<NSNumber *> *times = [self runTests];
    NSLog(@"CocoalumberJack logging    : %f", times[0].doubleValue);
    NSLog(@"story Teller logging       : %f", times[1].doubleValue);

    ddLogLevel = DDLogLevelInfo;
    [[STStoryTeller storyTeller] reset];
    startLogging(@"[UIView].hidden == YES");

    times = [self runTests];
    NSLog(@"CocoalumberJack logging off: %f", times[0].doubleValue);
    NSLog(@"story Teller logging off   : %f", times[1].doubleValue);


}

-(NSArray<NSNumber *> *) runTests {

    double storyTellerTimes[10];
    double cocoaLumberJackTimes[10];
    for (int t = 0; t < 10; t++) {
        cocoaLumberJackTimes[t] = [self runWithStatement:^(UIView *view, int idx){
            DDLogDebug(@"Logging %@ %i", view, idx);
        }];
        storyTellerTimes[t] = [self runWithStatement:^(UIView *view, int idx){
            log(view, @"Logging %@ %i", view, idx);
        }];
    }

    double storyTellerTotal;
    double cocoaLumberJackTotal;
    for (int t = 0; t < 10; t++) {
        storyTellerTotal += storyTellerTimes[t];
        cocoaLumberJackTotal += cocoaLumberJackTimes[t];
    }
    return @[@(cocoaLumberJackTotal / 10), @(storyTellerTotal / 10)];
}

-(double) runWithStatement:(void (^)(UIView *view, int idx)) logBlock {
    UIView *view = [[UIView alloc] init];
    double startTime = [[NSDate date] timeIntervalSince1970];
    for (int i = 0; i < 1000; i++) {
        logBlock(view, i);
    }
    double endTime = [[NSDate date] timeIntervalSince1970];
    return endTime - startTime;
}

@end
