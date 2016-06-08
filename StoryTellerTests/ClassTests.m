//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import ObjectiveC;

@import StoryTeller.Private;

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
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]"];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testClassIsUnknown {
    @try {
        [_factory parseExpression:@"[Abc]"];
        XCTFail(@"Exception not thrown");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"Unable to find a class called Abc\nLine : Unknown\n", e.description);
    }
}

-(void) testClassFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]"];
    XCTAssertFalse([matcher matches:@12]);
}

-(void) testClassFailsMatchWhenDifferentClass {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]"];
    XCTAssertFalse([matcher matches:[NSNumber class]]);
}

-(void) testClassFailsMatchWhenClass {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]"];
    XCTAssertTrue([matcher matches:[NSString class]]);
}

-(void) testIsaClassMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"is [MainClass]"];
    XCTAssertTrue([matcher matches:[MainClass class]]);
}

-(void) testIsaClassFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"is [MainClass]"];
    XCTAssertFalse([matcher matches:[NSString class]]);
}

@end
