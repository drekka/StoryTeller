//
//  StoryTeller.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STStoryTeller.h"
#import "STConfig.h"
#import "STMatcher.h"
#import "STLogger.h"
#import "STLogExpressionParserDelegate.h"
#import "STDeallocHook.h"

NS_ASSUME_NONNULL_BEGIN

void STStartLogging(NSString *expression) {
    [[STStoryTeller instance] startLogging:expression];
}

@implementation STStoryTeller {
    NSMutableSet *_activeKeys;
    NSMutableSet<id<STMatcher>> *_logMatchers;
    STConfig *_config;
    STLogExpressionParserDelegate *_expressionMatcherFactory;
}

#pragma mark - Singleton setup

static __strong STStoryTeller *__storyTeller;

+(instancetype) instance {
    @synchronized (self) {
        if (!__storyTeller) {
            __storyTeller = [[STStoryTeller alloc] init];
            [__storyTeller->_config configure:__storyTeller];
        }
    }
    return __storyTeller;
}

#pragma mark - Debugging

+(void) reset {
    @synchronized (self) {
        __storyTeller = nil;
    }
}

+(void) clearMatchers {
    @synchronized (self) {
        __storyTeller->_logMatchers = [[NSMutableSet alloc] init];
    }
}

#pragma mark - Lifecycle

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

#pragma mark - Activating logging

-(void) startLogging:(NSString *) keyExpression {
    NSLog(@"Story Teller: Activating log: %@", keyExpression);
    id<STMatcher> matcher = [_expressionMatcherFactory parseExpression:keyExpression];
    
    if (_logMatchers.count > 0) {
        if (matcher.exclusive) {
            @throw [NSException exceptionWithName:@"StoryTellerConfigException" reason:[NSString stringWithFormat:@"%@ cannot be used with other logging expressions", keyExpression] userInfo:nil];
        } else if ([_logMatchers anyObject].exclusive) {
            @throw [NSException exceptionWithName:@"StoryTellerConfigException" reason:[NSString stringWithFormat:@"Log expression %@ cannot be used with previous exclusive expressions", keyExpression] userInfo:nil];
        }
    }
    
    [_logMatchers addObject:matcher];
}

#pragma mark - Activating

-(int) numberActiveScopes {
    return (int)[_activeKeys count];
}

-(id) startScope:(__weak id) key {
    [_activeKeys addObject:key];
    return [[STDeallocHook alloc] initWithBlock:^{
        [[STStoryTeller instance] endScope:key];
    }];
}

-(void) endScope:(__weak id) key {
    [_activeKeys removeObject:key];
}

-(BOOL) isScopeActive:(__weak id) key {
    return [_activeKeys containsObject:key];
}

#pragma mark - Logging

-(void) record:(id) key
          file:(const char *) fileName
        method:(const char *) methodName
    lineNumber:(int) lineNumber
       message:(NSString *) messageTemplate, ... {
    va_list args;
    va_start(args, messageTemplate);
    [self record:key
            file:fileName
          method:methodName
      lineNumber:lineNumber
         message:messageTemplate
            args:args];
    va_end(args);
}

-(void) record:(id) key
          file:(const char *) fileName
        method:(const char *) methodName
    lineNumber:(int) lineNumber
       message:(NSString *) messageTemplate
          args:(va_list) args {
    
    // Only continue if the key is being logged.
    if (![self shouldLogKey:key]) {
        return;
    }
    
    // Assemble the main message.
    NSString *msg = [[NSString alloc] initWithFormat:messageTemplate arguments:args];

    // And give it to the scribe.
    [self.logger writeMessage:msg
                     fromFile:fileName
                   fromMethod:methodName
                   lineNumber:lineNumber
                          key:key];
}

-(void) execute:(id) key block:(void (^)()) block {
    if ([self shouldLogKey:key]) {
        block();
    }
}

-(BOOL) shouldLogKey:(id) key {
    
    // Check the bypass and active keys.
    if ([self isKeyMatched:key]) {
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
        if ([matcher storyTeller:self matches:key]) {
            return YES;
        }
    }
    return NO;
}

@end

NS_ASSUME_NONNULL_END
