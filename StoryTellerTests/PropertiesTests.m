//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import StoryTeller;
@import StoryTeller.Private;
@import OCMock;

#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"


@interface PropertiesTests : XCTestCase
@end

@implementation PropertiesTests {
    STLogExpressionParserDelegate *_factory;
    id _mockStoryTeller;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
}

-(void) testUnknownKey {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intPropertyxxx == abc"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertThrowsSpecificNamed([matcher storyTeller:_mockStoryTeller matches:mainClass], NSException, @"NSUnknownKeyException");
}

@end
