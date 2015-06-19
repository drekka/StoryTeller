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

#define startChronicle(hero) \
_Pragma ("clang diagnostic push") \
_Pragma ("clang diagnostic ignored \"-Wunused-variable\"") \
NS_VALID_UNTIL_END_OF_SCOPE STDeallocHook *ST_CONCATINATE(hook_, __LINE__) = [[STDeallocHook alloc] initWithBlock:^{ \
[[StoryTeller narrator] finishChronicleFor:hero]; \
}]; \
_Pragma ("clang diagnostic pop") \
[[StoryTeller narrator] startChronicleFor:hero]

#define finishChronicle(hero) \
[[StoryTeller narrator] finishChronicleFor:hero]

#define narrate(hero, messageTemplate, ...) \
[[StoryTeller narrator] addToChronicleFor:hero method: __PRETTY_FUNCTION__ lineNumber: __LINE__ message:messageTemplate, ## __VA_ARGS__]

@interface StoryTeller : NSObject

+(StoryTeller __nonnull *) narrator;

@property (nonatomic, assign, nonnull) Class scribeClass;
@property (nonatomic, assign, nonnull, readonly) id<STScribe> scribe;
@property (nonatomic, assign, readonly) int numberActiveChronicles;

-(void) startChronicleFor:(id __nonnull) hero;

-(void) finishChronicleFor:(id __nonnull) hero;

-(void) addToChronicleFor:(id __nonnull) hero
                   method:(const char __nonnull *) methodName
               lineNumber:(int) lineNumber
                  message:(NSString __nonnull *) message, ...;

@end
