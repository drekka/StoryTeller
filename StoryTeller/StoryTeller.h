//
//  StoryTeller.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STScribe.h"

#define narrate(hero, message)

@interface StoryTeller : NSObject

+(StoryTeller __nonnull *) narrator;

@property (nonatomic, assign, nonnull) Class scribeClass;
@property (nonatomic, assign, nonnull, readonly) id<STScribe> scribe;

-(void) startStoryFor:(id __nonnull) hero;

-(void) stopStoryFor:(id __nonnull) hero;

@end
