//
//  StoryTeller.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STScribe.h"
#import "STDeallocHook.h"
#import "STInternal.h"

#pragma mark - Main macros

#define storyteller [StoryTeller narrator]

#define tellStory(hero)

#define activate(hero) \
_Pragma ("clang diagnostic push") \
_Pragma ("clang diagnostic ignored \"-Wunused-variable\"") \
NS_VALID_UNTIL_END_OF_SCOPE STDeallocHook *ST_CONCATINATE(_stHook_, __LINE__) = [[STDeallocHook alloc] initWithBlock:^{ \
deactivate(hero); \
}]; \
_Pragma ("clang diagnostic pop") \
[storyteller activateStoryFor:hero]

#define deactivate(hero) \
[storyteller deactivateStoryFor:hero]

#define record(hero, messageTemplate, ...) \
[storyteller recordFor:hero addMethod: __PRETTY_FUNCTION__ lineNumber: __LINE__ message:messageTemplate, ## __VA_ARGS__]

#define executeBlockFor(hero, block) \
[storyteller for:hero executeBlock:block]

@interface StoryTeller : NSObject

#pragma mark - Story teller

+(StoryTeller __nonnull *) narrator;

@property (nonatomic, assign, nonnull) Class scribeClass;
@property (nonatomic, assign, nonnull, readonly) id<STScribe> scribe;

#pragma mark - Chronicles

@property (nonatomic, assign, readonly) int numberActiveChronicles;

-(void) activateStoryFor:(id __nonnull) hero;

-(void) deactivateStoryFor:(id __nonnull) hero;

-(BOOL) isStoryActiveFor:(id __nonnull) hero;

#pragma mark - Logging

-(void) for:(id __nonnull) hero recordMethod:(const char __nonnull *) methodName lineNumber:(int) lineNumber message:(NSString __nonnull *) messageTemplate, ...;

-(void) for:(id __nonnull) hero executeBlock:(__nonnull void (^)(id __nonnull hero)) recordBlock;

@end
