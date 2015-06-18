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
    XCTAssertEqualObjects([self.inMemoryScribe.log[0] substringFromIndex:13], @"a07 -[StoryTellerTests testBasicLogging] [20] hello world");
}

-(void) testLoggingIgnoredWhenHeroNotStarted {
    narrate(@"abc", @"hello world");
    XCTAssertEqual(0lu, [self.inMemoryScribe.log count]);
}

@end
