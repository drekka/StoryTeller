//
//  StoryTellerTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import StoryTeller;
@import StoryTeller.Private;
@import OCMock;

#import "InMemoryLogger.h"
#import "STStoryTeller+Internal.h"

@interface StoryTellerTests : XCTestCase
@end

@implementation StoryTellerTests {
    int _helloAgainLogLine;
    const char *_helloAgainMethodName;
    InMemoryLogger *_inMemoryLogger;
}

-(void) setUp {
    _inMemoryLogger = [[InMemoryLogger alloc] init];
    [STStoryTeller instance].logger = _inMemoryLogger;
}

-(void) tearDown {
    [STStoryTeller reset];
}

-(void) testActivatingKeyScope {
    STStartScope(@"abc");
    XCTAssertTrue([[STStoryTeller instance] isScopeActive:@"abc"]);
    XCTAssertFalse([[STStoryTeller instance] isScopeActive:@"def"]);
}

-(void) testMessageRecordedWhenKeyLogging {
    int logLine = __LINE__ + 1;
    STLog(@"abc", @"hello world");
    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine message:@"hello world"];
}

-(void) testMessageRecordedWhenKeyNotLogging {
    XCTAssertEqual(0lu, [_inMemoryLogger.log count]);
    STLog(@"xyz", @"hello world");
    XCTAssertEqual(0lu, [_inMemoryLogger.log count]);
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
        STLog(key, @"hello world %@", key);
        XCTAssertEqual(1, [STStoryTeller instance].numberActiveScopes);
    }];
    
    XCTAssertEqual(02u, [_inMemoryLogger.log count]);
    [self validateLogLineAtIndex:0 methodName:blockMethodName lineNumber:logLineNumbers[0].intValue message:@"hello world abc"];
    [self validateLogLineAtIndex:1 methodName:blockMethodName lineNumber:logLineNumbers[1].intValue message:@"hello world def"];
}

-(void) testScopeEnablesLoggingFromNestedCalls {
    
    STStartScope(@"abc");
    
    int logLine = __LINE__ + 1;
    STLog(@"abc", @"hello world");
    [self sayHelloAgain];
    
    XCTAssertEqual(2lu, [_inMemoryLogger.log count]);
    
    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine message:@"hello world"];
    [self validateLogLineAtIndex:1 methodName:_helloAgainMethodName lineNumber:_helloAgainLogLine message:@"hello world 2"];
}

-(void) testExecuteBlock {
    STStartScope(@"abc");
    __block BOOL blockCalled = NO;
    STExecuteBlock(@"abc", ^ {
        blockCalled = YES;
    });
    XCTAssertTrue(blockCalled);
}

-(void) testLogAll {

    [STStoryTeller clearMatchers];

    STStartLogging(@"LogAll");

    int logLine1 = __LINE__ + 1;
    STLog(@"xyz", @"hello world 1");
    STStartScope(@"abc");
    int logLine2 = __LINE__ + 1;
    STLog(@"xyz", @"hello world 2");
    int logLine3 = __LINE__ + 1;
    STLog(@"def", @"hello world 3");
    
    XCTAssertEqual(3lu, [_inMemoryLogger.log count]);
    
    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine1 message:@"hello world 1"];
    [self validateLogLineAtIndex:1 methodName:__PRETTY_FUNCTION__ lineNumber:logLine2 message:@"hello world 2"];
    [self validateLogLineAtIndex:2 methodName:__PRETTY_FUNCTION__ lineNumber:logLine3 message:@"hello world 3"];
}

-(void) testLogRoot {
    
    [STStoryTeller clearMatchers];

    STStartLogging(@"LogRoots");

    int logLine1 = __LINE__ + 1;
    STLog(@"xyz", @"hello world 1");
    STStartScope(@"def");
    STLog(@"xyz", @"hello world 2");
    STLog(@"def", @"hello world 3");
    
    XCTAssertEqual(1lu, [_inMemoryLogger.log count]);
    
    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine1 message:@"hello world 1"];
}

-(void) testStartLoggingWithNonExistantClass {
    XCTAssertThrowsSpecificNamed([[STStoryTeller instance] startLogging:@"[XXXX]"], NSException, @"StoryTellerParseException");
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
    XCTAssertEqualObjects(expected, [_inMemoryLogger.log[idx] substringFromIndex:13]);
}

@end
