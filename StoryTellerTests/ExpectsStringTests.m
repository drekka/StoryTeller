//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
#import "STLogExpressionParserDelegate.h"
#import "STMatcher.h"
#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"

@interface ExpectsStringTests : XCTestCase
@end

@implementation ExpectsStringTests {
    STLogExpressionParserDelegate *_factory;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
}

-(void) testQuotedStringMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == \"abc\"" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"abc";
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == abc" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"abc";
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == abc" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testFailsMatchWhenAProtocolProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].protocolProperty == abc" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testFailsMatchWhenAIntProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty == abc" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    XCTAssertFalse([matcher matches:mainClass]);
}

@end
