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
    NSMutableSet *_activeSubjects;
}

static StoryTeller *__storyTeller;

#pragma mark - Lifecycle

+(void) initialize {
    __storyTeller = [[StoryTeller alloc] init];
}

-(instancetype) init {
    self = [super init];
    if (self) {
        self.logger = [[STConsoleLogger alloc] init];
        _activeSubjects = [[NSMutableSet alloc] init];
        _logger = [[STConsoleLogger alloc] init];
    }
    return self;
}

#pragma mark - Story teller

+(StoryTeller __nonnull *) storyTeller {
    return __storyTeller;
}

#pragma mark - Activating logging

-(void) startLoggingSubject:(id __nonnull) subject {

}

-(void) stopLoggingSubject:(id __nonnull) subject {

}

#pragma mark - Activating

-(int) numberActiveSubjects {
    return (int)[_activeSubjects count];
}

-(void) addSubjectToActiveList:(id __nonnull)subject {
    [_activeSubjects addObject:subject];
}

-(void) removeSubjectFromActiveList:(id __nonnull)subject {
    [_activeSubjects removeObject:subject];
}

-(BOOL) isSubjectActive:(id __nonnull) subject {
    return [_activeSubjects containsObject:subject];
}

#pragma mark - Logging

-(void) subject:(id __nonnull) subject recordMethod:(const char __nonnull *) methodName lineNumber:(int) lineNumber message:(NSString __nonnull *) messageTemplate, ... {

    // Only continue if the hero is being logged.
    if (![self loggingSubject:subject]) {
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

-(void) subject:(id __nonnull) subject executeBlock:(__nonnull void (^)(id __nonnull hero)) recordBlock {

    // Only continue if the hero is being logged.
    if (![self loggingSubject:subject]) {
        return;
    }

    recordBlock(subject);
}

-(BOOL) loggingSubject:(id) subject {
    return [_activeSubjects count] > 0 || [_activeSubjects containsObject:subject];
}

@end
