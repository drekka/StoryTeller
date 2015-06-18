//
//  StoryTeller.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STScribe.h"

#define narrate(hero, message) \
[[StoryTeller narrator] writeMessage:(message) \
fromMethod: __PRETTY_FUNCTION__ \
lineNumber: __LINE__]

@interface StoryTeller : NSObject

+(StoryTeller __nonnull *) narrator;

@property (nonatomic, assign, nonnull) Class scribeClass;
@property (nonatomic, assign, nonnull, readonly) id<STScribe> scribe;

-(void) startStoryFor:(id __nonnull) hero;

-(void) stopStoryFor:(id __nonnull) hero;

-(void) writeMessage:(NSString __nonnull *) message
          fromMethod:(const char __nonnull *) methodName
          lineNumber:(int) lineNumber;

@end
