//
//  STTestCase.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import StoryTeller;

#import "STTestCase.h"
#import "InMemoryLogger.h"

@implementation STTestCase

-(void) setUp {
    [STStoryTeller start];
    [STStoryTeller storyTeller].logger = [[InMemoryLogger alloc] init];
}

-(InMemoryLogger *) inMemoryLogger {
    return (InMemoryLogger *) [STStoryTeller storyTeller].logger;
}

@end
