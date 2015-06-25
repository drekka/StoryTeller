//
//  STClassMatcherTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;

#import "STClassMatcher.h"

@interface STClassMatcherTests : XCTestCase

@end

@implementation STClassMatcherTests

-(void) testMatches {
    STClassMatcher *matcher = [[STClassMatcher alloc] initWithClass:[NSString class]];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testFailsToMatch {
    STClassMatcher *matcher = [[STClassMatcher alloc] initWithClass:[NSString class]];
    XCTAssertFalse([matcher matches:@12]);
}

@end
