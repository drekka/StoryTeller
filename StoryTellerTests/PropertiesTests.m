//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import StoryTeller.Private;
#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"

@interface PropertiesTests : XCTestCase
@end

@implementation PropertiesTests {
    STLogExpressionParserDelegate *_factory;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
}

-(void) testUnknown {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intPropertyxxx == abc" error:&error];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertThrowsSpecificNamed([matcher matches:mainClass], NSException, @"NSUnknownKeyException");
}

@end
