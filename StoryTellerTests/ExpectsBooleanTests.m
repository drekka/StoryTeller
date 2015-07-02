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


-(void) testTrueMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == true" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testFalseMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == false" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testNoMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == NO" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testNotFalseMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty != false" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testYesMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == YES" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testFailsMatchWhenAInstanceProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty == YES" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testFailsMatchWhenAStringProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == YES" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testFailsMatchWhenAProtocolProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].protocolProperty == YES" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testFailsMatchWhenAIntProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty == YES" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testInvalidOp {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty > YES" error:&error];
    XCTAssertNil(matcher);
    XCTAssertEqualObjects(@"Failed to match next input token", error.localizedDescription);
}

@end
