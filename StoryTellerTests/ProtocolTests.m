//
//  STExpressionMatcherFactoryTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
#import "STExpressionMatcherFactory.h"
#import "STMatcher.h"
#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"

@interface ProtocolTests : XCTestCase
@end

@implementation ProtocolTests {
    STExpressionMatcherFactory *_factory;
}

-(void) setUp {
    _factory = [[STExpressionMatcherFactory alloc] init];
}

-(void) testMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"<NSCopying>" error:NULL];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"<NSFastEnumeration>" error:NULL];
    XCTAssertFalse([matcher matches:@"abc"]);
}

-(void) testUnknownProtocol {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"<Abc>" error:&error];
    XCTAssertNil(matcher);
    XCTAssertEqualObjects(@"Unable to find a protocol called Abc\nLine : Unknown\n", error.localizedFailureReason);
}

-(void) testIsaMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"is <AProtocol>" error:NULL];
    XCTAssertTrue([matcher matches:@protocol(AProtocol)]);
}

-(void) testIsaFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"is <NSCopying>" error:NULL];
    XCTAssertFalse([matcher matches:@protocol(AProtocol)]);
}

-(void) testIsaFailsMatchWhenNotAProtocol {
    id<STMatcher> matcher = [_factory parseExpression:@"is <NSCopying>" error:NULL];
    XCTAssertFalse([matcher matches:@(12)]);
}

@end