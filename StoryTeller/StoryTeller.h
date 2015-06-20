//
//  StoryTeller.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STLogger.h"
#import "STDeallocHook.h"
#import "STInternal.h"

#pragma mark - Main macros

#define storyteller [StoryTeller storyTeller]

#define logSubject(subject)

#define addActiveSubject(subject) \
_Pragma ("clang diagnostic push") \
_Pragma ("clang diagnostic ignored \"-Wunused-variable\"") \
NS_VALID_UNTIL_END_OF_SCOPE STDeallocHook *ST_CONCATINATE(_stHook_, __LINE__) = [[STDeallocHook alloc] initWithBlock:^{ \
removeActiveSubject(subject); \
}]; \
_Pragma ("clang diagnostic pop") \
[storyteller addSubjectToActiveList:subject]

#define removeActiveSubject(subject) \
[storyteller removeSubjectFromActiveList:subject]

#define record(hero, messageTemplate, ...) \
[storyteller for:hero recordMethod: __PRETTY_FUNCTION__ lineNumber: __LINE__ message:messageTemplate, ## __VA_ARGS__]

#define executeBlockFor(hero, block) \
[storyteller for:hero executeBlock:block]

@interface StoryTeller : NSObject

#pragma mark - Story teller

+(StoryTeller __nonnull *) storyTeller;

@property (nonatomic, strong, nonnull) id<STLogger> logger;

#pragma mark - Activating logging

-(void) startLoggingSubject:(id __nonnull) subject;

-(void) stopLoggingSubject:(id __nonnull) subject;

#pragma mark - Stories

@property (nonatomic, assign, readonly) int numberActiveSubjects;

-(void) addSubjectToActiveList:(id __nonnull) subject;

-(void) removeSubjectFromActiveList:(id __nonnull) subject;

-(BOOL) isSubjectActive:(id __nonnull) subject;

#pragma mark - Logging

-(void) subject:(id __nonnull) subject recordMethod:(const char __nonnull *) methodName lineNumber:(int) lineNumber message:(NSString __nonnull *) messageTemplate, ...;

-(void) subject:(id __nonnull) subject executeBlock:(__nonnull void (^)(id __nonnull hero)) recordBlock;

@end
