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

@interface ExpectsNilTests : XCTestCase
@end

@implementation ExpectsNilTests {
    STLogExpressionParserDelegate *_factory;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
}

#pragma mark - General Properties

-(void) testMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == nil" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testNotEqualMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty != nil" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == nil" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertFalse([matcher matches:mainClass]);
}

@end
