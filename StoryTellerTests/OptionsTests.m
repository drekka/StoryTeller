//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
#import <OCMock/OCMock.h>
@import StoryTeller;
@import StoryTeller.Private;

@interface OptionsTests : XCTestCase
@end

@implementation OptionsTests {
    STLogExpressionParserDelegate *_factory;
    id _mockStoryTeller;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];

    // Mock out story teller.
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
    OCMStub([_mockStoryTeller storyTeller]).andReturn(_mockStoryTeller);
}

-(void) tearDown {
    [_mockStoryTeller stopMocking];
}

#pragma mark - Options

-(void) testLogAll {
    id<STMatcher> matcher = [_factory parseExpression:@"LogAll"];
    XCTAssertNil(matcher);
    OCMVerify([_mockStoryTeller logAll]);
}

-(void) testLogRoots {
    id<STMatcher> matcher = [_factory parseExpression:@"LogRoots"];
    XCTAssertNil(matcher);
    OCMVerify([_mockStoryTeller logRoots]);
}

@end
