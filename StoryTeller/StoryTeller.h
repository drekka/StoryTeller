//
//  StoryTeller.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STScribe.h"

#define startStory(hero) \
[[StoryTeller narrator] startStoryFor:hero]

#define finishStory(hero) \
[[StoryTeller narrator] finishStoryFor:hero]

#define narrate(hero, messageTemplate, ...) \
[[StoryTeller narrator] writeHero:hero \
method: __PRETTY_FUNCTION__ \
lineNumber: __LINE__ \
message:messageTemplate, ## __VA_ARGS__]

@interface StoryTeller : NSObject

+(StoryTeller __nonnull *) narrator;

@property (nonatomic, assign, nonnull) Class scribeClass;
@property (nonatomic, assign, nonnull, readonly) id<STScribe> scribe;

-(void) startStoryFor:(id __nonnull) hero;

-(void) finishStoryFor:(id __nonnull) hero;

-(void) writeHero:(id __nonnull) hero
           method:(const char __nonnull *) methodName
       lineNumber:(int) lineNumber
          message:(NSString __nonnull *) message, ...;

@end
