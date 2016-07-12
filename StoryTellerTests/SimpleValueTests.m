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

@interface SimpleValueTests : XCTestCase
@end

@implementation SimpleValueTests {
    STLogExpressionParserDelegate *_factory;
    id _mockStoryTeller;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
}

#pragma mark - Simple values

-(void) testStringMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"abc"];
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:@"abc"]);
}

-(void) testStringFailsMatchWhenANumber {
    id<STMatcher> matcher = [_factory parseExpression:@"abc"];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:@12]);
}

-(void) testStringFailsMatchWhenAClass {
    id<STMatcher> matcher = [_factory parseExpression:@"abc"];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:[NSNumber class]]);
}

-(void) testStringMatchesWhereStringIsClassName {
    id<STMatcher> matcher = [_factory parseExpression:@"NSString"];
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:@"NSString"]);
}

-(void) testStringFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"abc"];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:@"def"]);
}

-(void) testNumberMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"12"];
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:@12]);
}

-(void) testNumberFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"12.5"];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:@12.678]);
}

-(void) testNumberFailsMatchWhenAString {
    id<STMatcher> matcher = [_factory parseExpression:@"12.5"];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:@"abc"]);
}

-(void) testNumberFailsMatchWhenAProtocol {
    id<STMatcher> matcher = [_factory parseExpression:@"12.5"];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:@protocol(NSCopying)]);
}

@end
