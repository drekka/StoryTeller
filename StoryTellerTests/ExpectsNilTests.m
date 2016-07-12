//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import StoryTeller;
@import StoryTeller.Private;
@import OCMock;

#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"

@interface ExpectsNilTests : XCTestCase
@end

@implementation ExpectsNilTests {
    STLogExpressionParserDelegate *_factory;
    id _mockStoryTeller;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
}

#pragma mark - General Properties

-(void) testMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == nil"];
    MainClass *mainClass = [[MainClass alloc] init];
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testNotEqualMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty != nil"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == nil"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

@end
