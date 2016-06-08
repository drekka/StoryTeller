//
//  STConfigTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 22/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import StoryTeller;
@import StoryTeller.Private;

#import <OCMock/OCMock.h>

#import "InMemoryLogger.h"

@interface STConfigTests : XCTestCase
@property (nonatomic, assign) BOOL booleanProperty;
@end

@implementation STConfigTests {
    id _mockProcessInfo;
}

-(void) tearDown {
    [_mockProcessInfo stopMocking];
}

-(void) testConfigWithDefault {
    
    // Test
    STConfig *config = [[STConfig alloc] init];
    STStoryTeller *mockStoryTeller = OCMClassMock([STStoryTeller class]);
    [config configure:mockStoryTeller];
    
    // Verify
    OCMVerify([mockStoryTeller setLogger:[OCMArg isKindOfClass:[STConsoleLogger class]]]);
}

-(void) testConfigReadsCommandLineArgs {
    
    [self mockProcessInfo];
    [self stubProcessInfoArguments:@[@"loggerClass=InMemoryLogger",
                                     @"log=abc log=def",
                                     @"logLineFormat=xyz"]];
    
    // Test
    STStoryTeller *mockStoryTeller = OCMClassMock([STStoryTeller class]);
    STConfig *config = [[STConfig alloc] init];
    [config configure:mockStoryTeller];
    
    // Verify
    OCMVerify([mockStoryTeller setLogger:[OCMArg isKindOfClass:[InMemoryLogger class]]]);
    OCMVerify([mockStoryTeller startLogging:@"abc"]);
    OCMVerify([mockStoryTeller startLogging:@"def"]);
}

-(void) testConfigReadsEnvironment {
    
    [self mockProcessInfo];
    [self stubProcessInfoEnvironment:@{@"loggerClass":@"InMemoryLogger",
                                       @"log":@"abc",
                                       @"log":@"def",
                                       @"logLineFormat":@"xyz"}];
    
    // Test
    STConfig *config = [[STConfig alloc] init];
    STStoryTeller *mockStoryTeller = OCMClassMock([STStoryTeller class]);
    [config configure:mockStoryTeller];
    
    // Verify
    OCMVerify([mockStoryTeller setLogger:[OCMArg isKindOfClass:[InMemoryLogger class]]]);
    OCMVerify([mockStoryTeller startLogging:@"abc"]);
    OCMVerify([mockStoryTeller startLogging:@"def"]);
}

-(void) testConfigArgumentsOverrideEnvironment {
    
    [self mockProcessInfo];
    [self stubProcessInfoEnvironment:@{@"loggerClass":@"EnvironmentLogger"}];
    [self stubProcessInfoArguments:@[@"loggerClass=ArgumentLogger"]];
    
    // Test
    STStoryTeller *mockStoryTeller = OCMClassMock([STStoryTeller class]);
    STConfig *config = [[STConfig alloc] init];
    @try {
        [config configure:mockStoryTeller];
        XCTFail(@"Exception not thrown");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(@"StoryTeller", exception.name);
        XCTAssertEqualObjects(@"Unknown class 'ArgumentLogger'", exception.reason);
    }
}


-(void) testConfigWithInvalidLoggerClass {
    
    [self mockProcessInfo];
    [self stubProcessInfoArguments:@[@"loggerClass=XXXXX"]];
    
    // Test
    STStoryTeller *mockStoryTeller = OCMClassMock([STStoryTeller class]);
    STConfig *config = [[STConfig alloc] init];
    @try {
        [config configure:mockStoryTeller];
        XCTFail(@"Exception not thrown");
    } @catch (NSException *exception) {
        XCTAssertEqualObjects(@"StoryTeller", exception.name);
        XCTAssertEqualObjects(@"Unknown class 'XXXXX'", exception.reason);
    }
}

#pragma mark - Internal

-(void) mockProcessInfo {
    _mockProcessInfo = OCMClassMock([NSProcessInfo class]);
    OCMStub(ClassMethod([_mockProcessInfo processInfo])).andReturn(_mockProcessInfo);
}

-(void) stubProcessInfoArguments:(NSArray<NSString *> *) args {
    OCMStub([(NSProcessInfo *)_mockProcessInfo arguments]).andReturn(args);
}

-(void) stubProcessInfoEnvironment:(NSDictionary<NSString *, NSString *> *) args {
    OCMStub([(NSProcessInfo *)_mockProcessInfo environment]).andReturn(args);
}

@end
