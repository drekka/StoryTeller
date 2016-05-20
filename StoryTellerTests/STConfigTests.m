//
//  STConfigTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 22/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
@import StoryTeller;
@import StoryTeller.Private;

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
    
    [self stubProcessInfoArguments:@[@"loggerClass=InMemoryLogger", @"log=abc log=def", @"logLineFormat=xyz"]];
    
    // Test
    STConfig *config = [[STConfig alloc] init];
    STStoryTeller *mockStoryTeller = OCMClassMock([STStoryTeller class]);
    [config configure:mockStoryTeller];
    
    // Verify
    OCMVerify([mockStoryTeller setLogger:[OCMArg isKindOfClass:[InMemoryLogger class]]]);
    OCMVerify([mockStoryTeller startLogging:@"abc"]);
    OCMVerify([mockStoryTeller startLogging:@"def"]);
}

-(void) testConfigWithInvalidLoggerClass {
    
    [self stubProcessInfoArguments:@[@"loggerClass=STConsoleLogger"]];
    
    // Test
    STConfig *config = [[STConfig alloc] init];
    id mockStoryTeller = OCMClassMock([STStoryTeller class]);
    [config configure:mockStoryTeller];
    
    // Verify
    Class loggerClass = [STConsoleLogger class];
    OCMVerify([(STStoryTeller *)mockStoryTeller setLogger:[OCMArg isKindOfClass:loggerClass]]);
}

-(void) stubProcessInfoArguments:(NSArray<NSString *> *) args {
    _mockProcessInfo = OCMClassMock([NSProcessInfo class]);
    OCMStub(ClassMethod([_mockProcessInfo processInfo])).andReturn(_mockProcessInfo);
    OCMStub([(NSProcessInfo *)_mockProcessInfo arguments]).andReturn(args);
}

@end
