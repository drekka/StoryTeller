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

@interface ExpectsBooleanTests : XCTestCase
@end

@implementation ExpectsBooleanTests {
    STExpressionMatcherFactory *_factory;
}

-(void) setUp {
    _factory = [[STExpressionMatcherFactory alloc] init];
}


-(void) testPropertyNestedBoolTrueMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == true" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyNestedBoolNotFalseMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty != false" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyNestedBoolYesMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == YES" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyNestedBoolInvalidOp {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty > YES" error:&error];
    XCTAssertNil(matcher);
    XCTAssertEqualObjects(@"Failed to match next input token", error.localizedDescription);
}

@end
