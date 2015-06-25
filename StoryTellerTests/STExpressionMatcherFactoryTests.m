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

#import "STClassMatcher.h"
#import "STProtocolMatcher.h"

@interface STExpressionMatcherFactoryTests : XCTestCase

@end

@implementation STExpressionMatcherFactoryTests

-(void) testParseClass {
    STExpressionMatcherFactory *factory = [[STExpressionMatcherFactory alloc] init];
    NSError *error = nil;
    id<STMatcher> matcher = [factory parseExpression:@"[NSString]" error:&error];
    XCTAssertTrue([matcher isKindOfClass:[STClassMatcher class]]);
    XCTAssertEqual([NSString class], ((STClassMatcher *) matcher).forClass);
}

-(void) testParseProtocol {
    STExpressionMatcherFactory *factory = [[STExpressionMatcherFactory alloc] init];
    NSError *error = nil;
    id<STMatcher> matcher = [factory parseExpression:@"<NSCopying>" error:&error];
    XCTAssertTrue([matcher isKindOfClass:[STProtocolMatcher class]]);
    XCTAssertEqual(@protocol(NSCopying), ((STProtocolMatcher *) matcher).protocol);
}

@end
