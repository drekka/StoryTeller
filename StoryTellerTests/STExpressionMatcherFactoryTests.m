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

@interface A : NSObject
@property (nonatomic, strong) NSString *string;
@end

@implementation A
@end

@interface STExpressionMatcherFactoryTests : XCTestCase
@end

@implementation STExpressionMatcherFactoryTests {
    STExpressionMatcherFactory *_factory;
}

-(void) setUp {
    _factory = [[STExpressionMatcherFactory alloc] init];
}

-(void) testStringMatches {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"abc" error:&error];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testStringFailsMatch {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"abc" error:&error];
    XCTAssertFalse([matcher matches:@"def"]);
}

-(void) testNumberMatches {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"12" error:&error];
    XCTAssertTrue([matcher matches:@12]);
}

-(void) testNumberFailsMatch {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"12.5" error:&error];
    XCTAssertFalse([matcher matches:@12.678]);
}

-(void) testClassMatches {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]" error:&error];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testClassUnknown {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[Abc]" error:&error];
    XCTAssertNil(matcher);
    XCTAssertEqualObjects(@"Unable to find class Abc\nLine : Unknown\n", error.localizedFailureReason);
}

-(void) testClassFailsMatch {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]" error:&error];
    XCTAssertFalse([matcher matches:@12]);
}

-(void) testClassStringPropertyQuotedMatches {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[A].string == \"abc\"" error:&error];

    A *a = [[A alloc] init];
    a.string = @"abc";
    XCTAssertTrue([matcher matches:a]);
}

-(void) testClassStringPropertyUnQuotedMatches {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[A].string == abc" error:&error];

    A *a = [[A alloc] init];
    a.string = @"abc";
    XCTAssertTrue([matcher matches:a]);
}

-(void) testClassStringPropertyUnQuotedFailsMatch {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[A].string == abc" error:&error];

    A *a = [[A alloc] init];
    a.string = @"def";
    XCTAssertFalse([matcher matches:a]);
}

-(void) testClassInvalidStringProperty {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[A].xxxx == abc" error:&error];

    A *a = [[A alloc] init];
    a.string = @"def";
    XCTAssertThrowsSpecificNamed([matcher matches:a], NSException, @"NSUnknownKeyException");
}

-(void) testProtocolMatches {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"<NSCopying>" error:&error];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testProtocolUnknown {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"<Abc>" error:&error];
    XCTAssertNil(matcher);
    XCTAssertEqualObjects(@"Unable to find protocol Abc\nLine : Unknown\n", error.localizedFailureReason);
}

-(void) testProtocolFailsMatch {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"<NSFastEnumeration>" error:&error];
    XCTAssertFalse([matcher matches:@12]);
}

@end
