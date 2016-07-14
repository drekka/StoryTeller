//
//  STMatcher.h
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;

@class STStoryTeller;

NS_ASSUME_NONNULL_BEGIN

/**
 A protocol that defines the interface for matchers. 
 */
@protocol STMatcher <NSObject>

/**
 Called when an key is being matched.

 @param key The key to be tested.

 @return YES if the matcher matches the key.
 */
-(BOOL) storyTeller:(STStoryTeller *) storyTeller matches:(id) key;

/**
 The next matcher in the chain.
 */
@property (nonatomic, strong, nullable) id<STMatcher> nextMatcher;

/**
 If YES, this matcher cannot be usd with other matchers. For example, the LogAll matcher.
 */
@property (nonatomic, assign) BOOL exclusive;

@end

NS_ASSUME_NONNULL_END
