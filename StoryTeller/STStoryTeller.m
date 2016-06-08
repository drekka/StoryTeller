//
//  StoryTeller.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <StoryTeller/STStoryTeller.h>
#import <StoryTeller/STConfig.h>
#import <StoryTeller/STMatcher.h>
#import <StoryTeller/STLogger.h>
#import <StoryTeller/STLogExpressionParserDelegate.h>
#import <StoryTeller/STDeallocHook.h>

@implementation STStoryTeller {
    NSMutableSet *_activeKeys;
    NSMutableSet<id<STMatcher>> *_logMatchers;
    STConfig *_config;
    STLogExpressionParserDelegate *_expressionMatcherFactory;
}

static __strong STStoryTeller *__storyTeller;

#pragma mark - Lifecycle

+(void) initialize {
#ifndef DISABLE_STORY_TELLER
    __storyTeller = [[STStoryTeller alloc] init];
    [__storyTeller->_config configure:__storyTeller];
#endif
}

+(STStoryTeller * _Nonnull) storyTeller {
    return __storyTeller;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _activeKeys = [[NSMutableSet alloc] init];
        _logMatchers = [[NSMutableSet alloc] init];
        _expressionMatcherFactory = [[STLogExpressionParserDelegate alloc] init];
        _config = [[STConfig alloc] init];
    }
    return self;
}

#pragma mark - Story teller

-(void) reset {
    [STStoryTeller initialize];
}

#pragma mark - Activating logging

-(void) logAll {
    NSLog(@"Story Teller: Activating all log statements");
    _logAll = YES;
    _logRoots = NO;
    [_logMatchers removeAllObjects];
}

-(void) logRoots {
    
    if (_logAll) {
        return;
    }
    
    NSLog(@"Story Teller: Activating root log statements");
    _logRoots = YES;
    [_logMatchers removeAllObjects];
}

-(void) startLogging:(NSString * _Nonnull) keyExpression {
    NSLog(@"Story Teller: Activating log: %@", keyExpression);
    id<STMatcher> matcher = [_expressionMatcherFactory parseExpression:keyExpression];
    [_logMatchers addObject:matcher];
}

#pragma mark - Activating

-(int) numberActiveScopes {
    return (int)[_activeKeys count];
}

-(id) startScope:(id _Nonnull) key {
    [_activeKeys addObject:key];
    return [[STDeallocHook alloc] initWithBlock:^{
        [[STStoryTeller storyTeller] endScope:key];
    }];
}

-(void) endScope:(id _Nonnull) key {
    [_activeKeys removeObject:key];
}

-(BOOL) isScopeActive:(id _Nonnull) key {
    return [_activeKeys containsObject:key];
}

#pragma mark - Logging

-(void) record:(id _Nonnull) key
          file:(const char * _Nonnull) fileName
        method:(const char * _Nonnull) methodName
    lineNumber:(int) lineNumber
       message:(NSString * _Nonnull) messageTemplate, ... {
    
    // Only continue if the key is being logged.
    if (![self shouldLogKey:key]) {
        return;
    }
    
    // Assemble the main message.
    va_list args;
    va_start(args, messageTemplate);
    NSString *msg = [[NSString alloc] initWithFormat:messageTemplate arguments:args];
    va_end(args);
    
    // And give it to the scribe.
    [self.logger writeMessage:msg
                     fromFile:fileName
                   fromMethod:methodName
                   lineNumber:lineNumber
                          key:key];
}

-(void) execute:(id _Nonnull) key block:(void (^ _Nonnull)(id _Nonnull)) block {
    if ([self shouldLogKey:key]) {
        block(key);
    }
}

-(BOOL) shouldLogKey:(id) key {
    
    // Check the bypass and active keys.
    if (_logAll || [self isKeyMatched:key]) {
        return YES;
    }
    
    // If logRoot is in effect we need to log as long as there are no scopes.
    if (_logRoots && [_activeKeys count] == 0) {
        return YES;
    }
    
    // If any of the active keys are logging then we also fire.
    for (id scopeKey in _activeKeys) {
        if ([self isKeyMatched:scopeKey]) {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL) isKeyMatched:(id) key {
    for (id<STMatcher> matcher in _logMatchers) {
        if ([matcher matches:key]) {
            return YES;
        }
    }
    return NO;
}

@end
