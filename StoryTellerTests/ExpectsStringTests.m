//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import StoryTeller.Private;
@import StoryTeller;
@import OCMock;

#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"

@interface ExpectsStringTests : XCTestCase
@end

@implementation ExpectsStringTests {
    STLogExpressionParserDelegate *_factory;
    id _mockStoryTeller;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
}

-(void) testQuotedStringMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == \"abc\""];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"abc";
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == abc"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"abc";
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == abc"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testFailsMatchWhenAProtocolProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].protocolProperty == abc"];
    MainClass *mainClass = [[MainClass alloc] init];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testFailsMatchWhenAIntProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty == abc"];
    MainClass *mainClass = [[MainClass alloc] init];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

@end
