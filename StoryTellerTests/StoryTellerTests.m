//
//  StoryTellerTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STTestCase.h"
#import "StoryTeller.h"

@interface StoryTellerTests : STTestCase

@end

@implementation StoryTellerTests

-(void) testBasicLogging {
    [[StoryTeller narrator] startStoryFor:@"abc"];
    narrate(@"abc", @"hello world");
    XCTAssertEqualObjects(self.inMemoryScribe.log[0], @"hello world");
}

@end
