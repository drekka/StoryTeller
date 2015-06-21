//
//  StoryTellerTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STTestCase.h"
#import "StoryTeller.h"

@interface StoryTellerTests : STTestCase

@end

@implementation StoryTellerTests {
    int _helloAgainLogLine;
    const char * _helloAgainMethodName;
}

-(void) setUp {
    [super setUp];
    startLogging(@"abc");
}

-(void) testActivatingKeyScope {
    startScope(@"abc");
    XCTAssertTrue([[StoryTeller storyTeller] isScopeActive:@"abc"]);
    XCTAssertFalse([[StoryTeller storyTeller] isScopeActive:@"def"]);
}

-(void) testMessageRecordedWhenKeyLogging {
    int logLine = __LINE__ + 1;
    log(@"abc", @"hello world");
    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine message:@"hello world"];
}

-(void) testMessageRecordedWhenKeyNotLogging {
    [[StoryTeller storyTeller] stopLogging:@"abc"];
    log(@"abc", @"hello world");
    XCTAssertEqual(0lu, [self.inMemoryLogger.log count]);
}

-(void) testScopesInLoops {

    startLogging(@"def");

    NSArray<NSString *> *heros = @[@"abc", @"def"];
    NSMutableArray<NSNumber *> *logLineNumbers = [@[] mutableCopy];

    __block const char *blockMethodName;
    [heros enumerateObjectsUsingBlock:^(NSString * __nonnull hero, NSUInteger idx, BOOL * __nonnull stop) {
        blockMethodName = __PRETTY_FUNCTION__;
        startScope(hero);
        logLineNumbers[idx] = @(__LINE__ + 1);
        log(hero, [NSString stringWithFormat:@"hello world %@", hero]);
        XCTAssertEqual(1, [StoryTeller storyTeller].numberActiveScopes);
    }];

    XCTAssertEqual(02u, [self.inMemoryLogger.log count]);
    [self validateLogLineAtIndex:0 methodName:blockMethodName lineNumber:logLineNumbers[0].intValue message:@"hello world abc"];
    [self validateLogLineAtIndex:1 methodName:blockMethodName lineNumber:logLineNumbers[1].intValue message:@"hello world def"];
}

-(void) testScopeEnablesLoggingFromNestedCalls {

    startScope(@"abc");

    int logLine = __LINE__ + 1;
    log(@"abc", @"hello world");
    [self sayHelloAgain];

    XCTAssertEqual(2lu, [self.inMemoryLogger.log count]);

    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine message:@"hello world"];
    [self validateLogLineAtIndex:1 methodName:_helloAgainMethodName lineNumber:_helloAgainLogLine message:@"hello world 2"];
}

-(void) testExecuteBlock {
    startScope(@"abc");
    __block BOOL blockCalled = NO;
    executeBlock(@"abc", ^(id key) {
        blockCalled = YES;
    });
    XCTAssertTrue(blockCalled);
}

-(void) validateLogLineAtIndex:(unsigned long) idx
                    methodName:(const char __nonnull *) methodName
                    lineNumber:(int) lineNumber
                       message:(NSString __nonnull *) message {
    NSString *expected = [NSString stringWithFormat:@"<a07> %s(%i) %@", methodName, lineNumber, message];
    XCTAssertEqualObjects(expected, [self.inMemoryLogger.log[idx] substringFromIndex:13]);
}

-(void) sayHelloAgain {
    _helloAgainMethodName = __PRETTY_FUNCTION__;
    _helloAgainLogLine = __LINE__ + 1;
    log(@"def", @"hello world 2");
}

@end
