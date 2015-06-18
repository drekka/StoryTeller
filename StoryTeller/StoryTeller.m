//
//  StoryTeller.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "StoryTeller.h"
#import "STScribe.h"
#import "STConsoleScribe.h"

@implementation StoryTeller {
    id<STScribe> _scribe;
}

static StoryTeller *__narrator;

+(void) initialize {
    __narrator = [[StoryTeller alloc] init];
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _scribeClass = [STConsoleScribe class];
    }
    return self;
}

+(StoryTeller __nonnull *) narrator {
    return __narrator;
}

-(id<STScribe> __nonnull) scribe {
    return _scribe;
}

-(void) setScribeClass:(Class __nonnull)scribeClass {
    _scribeClass = scribeClass;
    _scribe = nil;
}

-(void) startStoryFor:(id __nonnull) hero {
    // Check for a scribe and create one if necessary.
    if (_scribe == nil) {
        _scribe = [[_scribeClass alloc] init];
    }
}

-(void) stopStoryFor:(id __nonnull) hero {}

@end
