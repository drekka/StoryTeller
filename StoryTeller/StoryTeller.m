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
    NSMutableSet *_chronicles;
}

static StoryTeller *__narrator;

+(void) initialize {
    __narrator = [[StoryTeller alloc] init];
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _scribeClass = [STConsoleScribe class];
        _chronicles = [[NSMutableSet alloc] init];
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

-(int) numberActiveChronicles {
    return (int)[_chronicles count];
}

-(void) startChronicleFor:(id __nonnull) hero {
    [_chronicles addObject:hero];
}

-(void) finishChronicleFor:(id __nonnull) hero {
    [_chronicles removeObject:hero];
}

-(void) addToChronicleFor:(id __nonnull) hero
           method:(const char __nonnull *) methodName
       lineNumber:(int) lineNumber
          message:(NSString __nonnull *) messageTemplate, ... {

    // Only continue if the hero is being logged.
    if ([_chronicles count] == 0 && ![_chronicles containsObject:hero]) {
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

@end
