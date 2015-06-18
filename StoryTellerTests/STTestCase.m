//
//  STTestCase.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STTestCase.h"
#import "StoryTeller.h"

@implementation STTestCase

-(void) setUp {
    [StoryTeller narrator].scribeClass = [InMemoryScribe class];
}

-(InMemoryScribe *) inMemoryScribe {
    return (InMemoryScribe *)[StoryTeller narrator].scribe;
}

@end
