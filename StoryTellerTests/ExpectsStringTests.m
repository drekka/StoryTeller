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

@interface ExpectsStringTests : XCTestCase
@end

@implementation ExpectsStringTests {
    STExpressionMatcherFactory *_factory;
}

-(void) setUp {
    _factory = [[STExpressionMatcherFactory alloc] init];
}

-(void) testQuotedStringMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == \"abc\"" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"abc";
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testUnQuotedStringMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == abc" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"abc";
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testUnQuotedStringFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == abc" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertFalse([matcher matches:mainClass]);
}

@end
