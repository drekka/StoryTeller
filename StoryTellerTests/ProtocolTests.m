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

@interface ProtocolTests : XCTestCase
@end

@implementation ProtocolTests {
    STLogExpressionParserDelegate *_factory;
    id _mockStoryTeller;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
}

-(void) testMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"<NSCopying>"];
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:@"abc"]);
}

-(void) testFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"<NSFastEnumeration>"];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:@"abc"]);
}

-(void) testUnknownProtocol {
    @try {
        [_factory parseExpression:@"<Abc>"];
        XCTFail(@"Exception not thrown");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"Unable to find a protocol called Abc\nLine : Unknown\n", e.description);
    }
}

@end
