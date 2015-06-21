//
//  StoryTeller.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "StoryTeller.h"
#import "STLogger.h"
#import "STConsoleLogger.h"

@implementation StoryTeller {
    NSMutableSet *_activeKeys;
    NSMutableSet *_activeLogs;
}

static StoryTeller *__storyTeller;

#pragma mark - Lifecycle

+(void) initialize {
    __storyTeller = [[StoryTeller alloc] init];
}

-(instancetype) init {
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

#pragma mark - Story teller

+(StoryTeller __nonnull *) storyTeller {
    return __storyTeller;
}

-(void) reset {
    self.logger = [[STConsoleLogger alloc] init];
    _activeKeys = [[NSMutableSet alloc] init];
    _logger = [[STConsoleLogger alloc] init];
    _activeLogs = [[NSMutableSet alloc] init];
}

#pragma mark - Activating logging

-(void) startLogging:(id __nonnull) key {
    [_activeLogs addObject:key];
}

-(void) stopLogging:(id __nonnull) key {
    [_activeLogs removeObject:key];
}

#pragma mark - Activating

-(int) numberActiveScopes {
    return (int)[_activeKeys count];
}

-(void) startScope:(id __nonnull) key {
    [_activeKeys addObject:key];
}

-(void) endScope:(id __nonnull) key {
    [_activeKeys removeObject:key];
}

-(BOOL) isScopeActive:(id __nonnull) key {
    return [_activeKeys containsObject:key];
}

#pragma mark - Logging

-(void) record:(id __nonnull) key method:(const char __nonnull *) methodName lineNumber:(int) lineNumber message:(NSString __nonnull *) messageTemplate, ... {

    // Only continue if the key is being logged.
    if (![self isLogging:key]) {
        return;
    }

    // Assemble the main message.
    va_list args;
    va_start(args, messageTemplate);
    NSString *msg = [[NSString alloc] initWithFormat:messageTemplate arguments:args];
    va_end(args);

    // And give it to the scribe.
    [self.logger writeMessage:msg
                   fromMethod:methodName
                   lineNumber:lineNumber];
}

-(void) execute:(id __nonnull) key block:(void (^ __nonnull)(id __nonnull)) block {

    // Only continue if the key is being logged.
    if (![self isLogging:key]) {
        return;
    }

    block(key);
}

-(BOOL) isLogging:(id) key {

    // if the key is active.
    if ([_activeLogs containsObject:key]) {
        return YES;
    }

    // If any of the active keys are logging then we also fire.
    for (id scopeKey in _activeKeys) {
        if ([_activeLogs containsObject:scopeKey]) {
            return YES;
        }
    }

    return NO;
}

@end
