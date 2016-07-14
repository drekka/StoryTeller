//
//  STMatcherFactoryTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 11/7/16.
//  Copyright © 2016 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import StoryTeller.Private;

@interface STMatcherFactoryTests : XCTestCase

@end

@implementation STMatcherFactoryTests

-(void) testLogAllMatcher {
    id<STMatcher> matcher = [STMatcherFactory allMatcher];
    XCTAssertTrue(matcher.exclusive);
}
@end
