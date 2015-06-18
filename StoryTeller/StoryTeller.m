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
    NSMutableSet *_herosWithStories;
}

static StoryTeller *__narrator;

+(void) initialize {
    __narrator = [[StoryTeller alloc] init];
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _scribeClass = [STConsoleScribe class];
        _herosWithStories = [[NSMutableSet alloc] init];
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
    [_herosWithStories addObject:hero];
}

-(void) finishStoryFor:(id __nonnull) hero {
    [_herosWithStories removeObject:hero];
}

-(void) writeHero:(id __nonnull) hero
           method:(const char __nonnull *) methodName
       lineNumber:(int) lineNumber
          message:(NSString __nonnull *) messageTemplate, ... {

    // Only continue if the hero is being logged.
    

    // Check for a scribe and create one if necessary.
    if (_scribe == nil) {
        _scribe = [[_scribeClass alloc] init];
    }

    va_list args;
    va_start(args, messageTemplate);
    NSString *msg = [[NSString alloc] initWithFormat:messageTemplate arguments:args];
    va_end(args);


    [self.scribe writeMessage:msg
                   fromMethod:methodName
                   lineNumber:lineNumber];
}

@end
