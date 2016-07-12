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

@interface ExpectsProtocolTests : XCTestCase
@end

@implementation ExpectsProtocolTests {
    STLogExpressionParserDelegate *_factory;
    id _mockStoryTeller;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
}

-(void) testMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty == <AProtocol>"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

-(void) testFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty == <NSCopying>"];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:mainClass]);
}

@end
