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
    NSMutableSet *_activeStories;
}

static StoryTeller *__narrator;

#pragma mark - Lifecycle

+(void) initialize {
    __narrator = [[StoryTeller alloc] init];
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _scribeClass = [STConsoleScribe class];
        _activeStories = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - Story teller

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

#pragma mark - Chronicles

-(int) numberActiveChronicles {
    return (int)[_activeStories count];
}

-(void) activateStoryFor:(id __nonnull) hero {
    [_activeStories addObject:hero];
}

-(void) deactivateStoryFor:(id __nonnull) hero {
    [_activeStories removeObject:hero];
}

-(BOOL) isStoryActiveFor:(id __nonnull) hero {
    return [_activeStories containsObject:hero];
}

#pragma mark - Logging

-(void) for:(id __nonnull) hero recordMethod:(const char __nonnull *) methodName lineNumber:(int) lineNumber message:(NSString __nonnull *) messageTemplate, ... {

    // Only continue if the hero is being logged.
    if (![self tellStoryFor:hero]) {
        return;
    }

    // Lazy load a scribe bceause scribes are lazy by nature.
    if (_scribe == nil) {
        _scribe = [[_scribeClass alloc] init];
    }

    // Assemble the main message.
    va_list args;
    va_start(args, messageTemplate);
    NSString *msg = [[NSString alloc] initWithFormat:messageTemplate arguments:args];
    va_end(args);

    // And give it to the scribe.
    [self.scribe writeMessage:msg
                   fromMethod:methodName
                   lineNumber:lineNumber];
}

-(void) for:(id __nonnull) hero executeBlock:(__nonnull void (^)(id __nonnull hero)) recordBlock {

    // Only continue if the hero is being logged.
    if (![self tellStoryFor:hero]) {
        return;
    }

    recordBlock(hero);
}

-(BOOL) tellStoryFor:(id) hero {
    return [_activeStories count] > 0 || [_activeStories containsObject:hero];
}

@end
