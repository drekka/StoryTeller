//
//  STCompareMatcherTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 26/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import StoryTeller;
@import StoryTeller.Private;
@import OCMock;

@interface STCompareMatcherTests : XCTestCase

@end

@implementation STCompareMatcherTests {
    id _mockStoryTeller;
}

-(void)setUp {
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
}

-(void) testCallsNextMatcherWhenMatches {
    
    __block BOOL compareCalled = NO;
    id mockMatcher = OCMProtocolMock(@protocol(STMatcher));
    OCMStub([mockMatcher storyTeller:_mockStoryTeller matches:@"abc"]).andReturn(YES);
    
    STCompareMatcher *matcher = [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id key) {
        compareCalled = YES;
        return YES;
    }];
    
    matcher.nextMatcher = mockMatcher;
    
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:@"abc"]);
    OCMVerify([mockMatcher storyTeller:_mockStoryTeller matches:@"abc"]);
    
}

@end
