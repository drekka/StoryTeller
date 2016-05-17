//
//  StoryTellerTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <StoryTeller/StoryTeller.h>

#import "STTestCase.h"

@interface StoryTellerTests : STTestCase

@end

@implementation StoryTellerTests {
    int _helloAgainLogLine;
    const char * _helloAgainMethodName;
}

-(void) setUp {
    [super setUp];
    STStartLogging(@"abc");
}

-(void) testActivatingKeyScope {
    STStartScope(@"abc");
    XCTAssertTrue([[STStoryTeller storyTeller] isScopeActive:@"abc"]);
    XCTAssertFalse([[STStoryTeller storyTeller] isScopeActive:@"def"]);
}

-(void) testMessageRecordedWhenKeyLogging {
    int logLine = __LINE__ + 1;
    STLog(@"abc", @"hello world");
    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine message:@"hello world"];
}

-(void) testMessageRecordedWhenKeyNotLogging {
    XCTAssertEqual(0lu, [self.inMemoryLogger.log count]);
    STLog(@"xyz", @"hello world");
    XCTAssertEqual(0lu, [self.inMemoryLogger.log count]);
}

-(void) testScopesInLoops {

    STStartLogging(@"def");

    NSArray<NSString *> *keys = @[@"abc", @"def"];
    NSMutableArray<NSNumber *> *logLineNumbers = [@[] mutableCopy];

    __block const char *blockMethodName;
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        blockMethodName = __PRETTY_FUNCTION__;
        STStartScope(key);
        logLineNumbers[idx] = @(__LINE__ + 1);
        STLog(key, [NSString stringWithFormat:@"hello world %@", key]);
        XCTAssertEqual(1, [STStoryTeller storyTeller].numberActiveScopes);
    }];

    XCTAssertEqual(02u, [self.inMemoryLogger.log count]);
    [self validateLogLineAtIndex:0 methodName:blockMethodName lineNumber:logLineNumbers[0].intValue message:@"hello world abc"];
    [self validateLogLineAtIndex:1 methodName:blockMethodName lineNumber:logLineNumbers[1].intValue message:@"hello world def"];
}

-(void) testScopeEnablesLoggingFromNestedCalls {

    STStartScope(@"abc");

    int logLine = __LINE__ + 1;
    STLog(@"abc", @"hello world");
    [self sayHelloAgain];

    XCTAssertEqual(2lu, [self.inMemoryLogger.log count]);

    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine message:@"hello world"];
    [self validateLogLineAtIndex:1 methodName:_helloAgainMethodName lineNumber:_helloAgainLogLine message:@"hello world 2"];
}

-(void) testExecuteBlock {
    STStartScope(@"abc");
    __block BOOL blockCalled = NO;
    STExecuteBlock(@"abc", ^(id key) {
        blockCalled = YES;
    });
    XCTAssertTrue(blockCalled);
}

-(void) testLogAll {

    [[STStoryTeller storyTeller] logAll];

    int logLine1 = __LINE__ + 1;
    STLog(@"xyz", @"hello world 1");
    STStartScope(@"abc");
    int logLine2 = __LINE__ + 1;
    STLog(@"xyz", @"hello world 2");
    int logLine3 = __LINE__ + 1;
    STLog(@"def", @"hello world 3");

    XCTAssertEqual(3lu, [self.inMemoryLogger.log count]);

    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine1 message:@"hello world 1"];
    [self validateLogLineAtIndex:1 methodName:__PRETTY_FUNCTION__ lineNumber:logLine2 message:@"hello world 2"];
    [self validateLogLineAtIndex:2 methodName:__PRETTY_FUNCTION__ lineNumber:logLine3 message:@"hello world 3"];
}

-(void) testLogRoot {

    [[STStoryTeller storyTeller] logRoots];

    int logLine1 = __LINE__ + 1;
    STLog(@"xyz", @"hello world 1");
    STStartScope(@"def");
    STLog(@"xyz", @"hello world 2");
    STLog(@"def", @"hello world 3");

    XCTAssertEqual(1lu, [self.inMemoryLogger.log count]);

    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine1 message:@"hello world 1"];
}

#pragma mark - Internal

-(void) sayHelloAgain {
    _helloAgainMethodName = __PRETTY_FUNCTION__;
    _helloAgainLogLine = __LINE__ + 1;
    STLog(@"def", @"hello world 2");
}

-(void) validateLogLineAtIndex:(unsigned long) idx
                    methodName:(const char * _Nonnull) methodName
                    lineNumber:(int) lineNumber
                       message:(NSString * _Nonnull) message {
    NSString *lastPathComponent = [NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding].lastPathComponent;
    NSString *expected = [NSString stringWithFormat:@"%@:%i %@", lastPathComponent, lineNumber, message];
    XCTAssertEqualObjects(expected, [self.inMemoryLogger.log[idx] substringFromIndex:13]);
}

@end
