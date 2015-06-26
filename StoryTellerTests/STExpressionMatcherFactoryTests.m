//
//  STExpressionMatcherFactoryTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
#import <OCMock/OCMock.h>

#import "STExpressionMatcherFactory.h"

#import "STMatcher.h"

@interface STExpressionMatcherFactoryTests : XCTestCase

@end

@implementation STExpressionMatcherFactoryTests {
    STExpressionMatcherFactory *_factory;
}

-(void) setUp {
    _factory = [[STExpressionMatcherFactory alloc] init];
}

-(void) testParseClass {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]" error:&error];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testParseUnknownClass {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[ABC]" error:&error];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testParseProtocol {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"<NSCopying>" error:&error];
    XCTAssertTrue([matcher matches:@"abc"]);
}

@end
