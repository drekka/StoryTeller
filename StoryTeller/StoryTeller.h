//
//  StoryTeller.h
//  StoryTeller
//
//  Created by Derek Clarkson on 22/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;

#import <StoryTeller/STInternal.h>
#import <StoryTeller/STDeallocHook.h>
#import <StoryTeller/STLogger.h>
#import <StoryTeller/STConsoleLogger.h>
#import <StoryTeller/STAbstractLogger.h>

//! Project version number for StoryTeller.
FOUNDATION_EXPORT double StoryTellerVersionNumber;

//! Project version string for StoryTeller.
FOUNDATION_EXPORT const unsigned char StoryTellerVersionString[];

#pragma mark - Main macros

#define startLogging(key) \
[[StoryTeller storyTeller] startLogging:key]

#define startScope(key) \
_Pragma ("clang diagnostic push") \
_Pragma ("clang diagnostic ignored \"-Wunused-variable\"") \
NS_VALID_UNTIL_END_OF_SCOPE STDeallocHook *ST_CONCATINATE(_stHook_, __LINE__) = [[STDeallocHook alloc] initWithBlock:^{ \
endScope(key); \
}]; \
_Pragma ("clang diagnostic pop") \
[[StoryTeller storyTeller] startScope:key]

#define endScope(key) \
[[StoryTeller storyTeller] endScope:key]

#define log(key, messageTemplate, ...) \
[[StoryTeller storyTeller] record:key method: __PRETTY_FUNCTION__ lineNumber: __LINE__ message:messageTemplate, ## __VA_ARGS__]

#define executeBlock(key, codeBlock) \
[[StoryTeller storyTeller] execute:key block:codeBlock]

#pragma mark - Main class

@interface StoryTeller : NSObject

+(StoryTeller __nonnull *) storyTeller;

/**
 Used mostly for debugging.
 */
-(void) reset;

@property (nonatomic, strong, nonnull) id<STLogger> logger;

@property (nonatomic, assign) BOOL logAll;

#pragma mark - Activating logging

-(void) startLogging:(id __nonnull) key;

-(void) stopLogging:(id __nonnull) key;

#pragma mark - Stories

@property (nonatomic, assign, readonly) int numberActiveScopes;

-(void) startScope:(id __nonnull) key;

-(void) endScope:(id __nonnull) key;

-(BOOL) isScopeActive:(id __nonnull) key;

#pragma mark - Logging

-(void) record:(id __nonnull) key method:(const char __nonnull *) methodName lineNumber:(int) lineNumber message:(NSString __nonnull *) messageTemplate, ...;

-(void) execute:(id __nonnull) key block:(__nonnull void (^)(id __nonnull key)) block;

@end

