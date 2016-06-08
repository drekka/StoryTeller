//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import StoryTeller.Private;
#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"

@interface ProtocolTests : XCTestCase
@end

@implementation ProtocolTests {
    STLogExpressionParserDelegate *_factory;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
}

-(void) testMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"<NSCopying>"];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"<NSFastEnumeration>"];
    XCTAssertFalse([matcher matches:@"abc"]);
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