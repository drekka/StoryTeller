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

@interface SimpleValueTests : XCTestCase
@end

@implementation SimpleValueTests {
    STLogExpressionParserDelegate *_factory;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
}

#pragma mark - Simple values

-(void) testStringMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"abc" error:NULL];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testStringFailsMatchWhenANumber {
    id<STMatcher> matcher = [_factory parseExpression:@"abc" error:NULL];
    XCTAssertFalse([matcher matches:@12]);
}

-(void) testStringFailsMatchWhenAClass {
    id<STMatcher> matcher = [_factory parseExpression:@"abc" error:NULL];
    XCTAssertFalse([matcher matches:[NSNumber class]]);
}

-(void) testStringMatchesWhereStringIsClassName {
    id<STMatcher> matcher = [_factory parseExpression:@"NSString" error:NULL];
    XCTAssertTrue([matcher matches:@"NSString"]);
}

-(void) testStringFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"abc" error:NULL];
    XCTAssertFalse([matcher matches:@"def"]);
}

-(void) testNumberMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"12" error:NULL];
    XCTAssertTrue([matcher matches:@12]);
}

-(void) testNumberFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"12.5" error:NULL];
    XCTAssertFalse([matcher matches:@12.678]);
}

-(void) testNumberFailsMatchWhenAString {
    id<STMatcher> matcher = [_factory parseExpression:@"12.5" error:NULL];
    XCTAssertFalse([matcher matches:@"abc"]);
}

-(void) testNumberFailsMatchWhenAProtocol {
    id<STMatcher> matcher = [_factory parseExpression:@"12.5" error:NULL];
    XCTAssertFalse([matcher matches:@protocol(NSCopying)]);
}

@end
