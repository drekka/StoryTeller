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

@interface ExpectsBooleanTests : XCTestCase
@end

@implementation ExpectsBooleanTests {
    STLogExpressionParserDelegate *_factory;
    id _mockStoryTeller;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
}

-(void) testTrueMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == true"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testFalseMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == false"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testNoMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == NO"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testNotFalseMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty != false"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testYesMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == YES"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

#pragma mark - Type checking

-(void) testWhenInstanceProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty == YES"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testWhenAStringProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == YES"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testWhenAProtocolProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].protocolProperty == YES"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testWhenAIntProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty == YES"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

#pragma mark - Op checking

-(void) testInvalidOp {
    XCTAssertThrowsSpecificNamed([_factory parseExpression:@"[MainClass].subClassProperty.boolProperty > YES"], NSException, @"StoryTellerParseException");
}

@end
