//
//  STProtocolMatcherTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;

#import "STProtocolMatcher.h"

@interface STProtocolMatcherTests : XCTestCase

@end

@implementation STProtocolMatcherTests

-(void) testMatches {
    STProtocolMatcher *matcher = [[STProtocolMatcher alloc] initWithProtocol:@protocol(NSCopying)];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testFailsToMatch {
    STProtocolMatcher *matcher = [[STProtocolMatcher alloc] initWithProtocol:@protocol(NSFastEnumeration)];
    XCTAssertFalse([matcher matches:@"abc"]);
}

@end
