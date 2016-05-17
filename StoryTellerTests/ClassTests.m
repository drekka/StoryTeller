//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import ObjectiveC;

#import <StoryTeller/StoryTeller.h>

#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"

@interface ClassTests : XCTestCase
@end

@implementation ClassTests {
    STLogExpressionParserDelegate *_factory;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
}

-(void) testRuntimeConforms {
    XCTAssertFalse(class_conformsToProtocol([NSString class], @protocol(NSObject)));
}

#pragma mark - Classes

-(void) testClassMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]" error:NULL];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testClassIsUnknown {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[Abc]" error:&error];
    XCTAssertNil(matcher);
    XCTAssertEqualObjects(@"Unable to find a class called Abc\nLine : Unknown\n", error.localizedFailureReason);
}

-(void) testClassFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]" error:NULL];
    XCTAssertFalse([matcher matches:@12]);
}

-(void) testClassFailsMatchWhenDifferentClass {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]" error:NULL];
    XCTAssertFalse([matcher matches:[NSNumber class]]);
}

-(void) testClassFailsMatchWhenClass {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]" error:NULL];
    XCTAssertTrue([matcher matches:[NSString class]]);
}

-(void) testIsaClassMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"is [MainClass]" error:NULL];
    XCTAssertTrue([matcher matches:[MainClass class]]);
}

-(void) testIsaClassFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"is [MainClass]" error:NULL];
    XCTAssertFalse([matcher matches:[NSString class]]);
}

@end
