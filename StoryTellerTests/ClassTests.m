//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import ObjectiveC;
@import OCMock;

@import StoryTeller;
@import StoryTeller.Private;

#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"

@interface ClassTests : XCTestCase
@end

@implementation ClassTests {
    STLogExpressionParserDelegate *_factory;
    id _mockStoryTeller;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
}

-(void) testRuntimeConforms {
    XCTAssertFalse(class_conformsToProtocol([NSString class], @protocol(NSObject)));
}

#pragma mark - Classes

-(void) testClassMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]"];
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:@"abc"]);
}

-(void) testClassMatchesSwiftName {

    // Create a fake class.
    Class newClass = objc_allocateClassPair([NSObject class], "MyProject.MyClass", 0);
    objc_registerClassPair(newClass);

    id obj = [[newClass alloc] init];

    id<STMatcher> matcher = [_factory parseExpression:@"[MyProject.MyClass]"];
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:obj]);
}

-(void) testClassMatchesSwiftNameWithSpacesInProjectName {

    // Create a fake class.
    Class newClass = objc_allocateClassPair([NSObject class], "MyProject_Name.MyClass", 0);
    objc_registerClassPair(newClass);

    id obj = [[newClass alloc] init];

    id<STMatcher> matcher = [_factory parseExpression:@"[MyProject_Name.MyClass]"];
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:obj]);
}

-(void) testInvalidClassNameFromPointsMaster {
    XCTAssertThrowsSpecificNamed([_factory parseExpression:@"Points_Master.Calculator"], NSException, @"StoryTellerParseException");
}

-(void) testClassIsUnknown {
    @try {
        [_factory parseExpression:@"[Abc]"];
        XCTFail(@"Exception not thrown");
    }
    @catch (NSException *e) {
        XCTAssertEqualObjects(@"Invalid expression: [Abc], error: Failed to match next input token", e.description);
    }
}

-(void) testClassFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]"];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:@12]);
}

-(void) testClassFailsMatchWhenDifferentClass {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]"];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:[NSNumber class]]);
}

-(void) testClassFailsMatchWhenClass {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]"];
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:[NSString class]]);
}

-(void) testIsaClassMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"is [MainClass]"];
    XCTAssertTrue([matcher storyTeller:_mockStoryTeller matches:[MainClass class]]);
}

-(void) testIsaClassFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"is [MainClass]"];
    XCTAssertFalse([matcher storyTeller:_mockStoryTeller matches:[NSString class]]);
}

@end
