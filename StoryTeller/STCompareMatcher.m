//
//  STGenericMatcher.m
//  StoryTeller
//
//  Created by Derek Clarkson on 26/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STCompareMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@implementation STCompareMatcher {
    BOOL (^_compareBlock)(STStoryTeller *storyTeller, id key);
}

@synthesize nextMatcher = _nextMatcher;
@synthesize exclusive = _exclusive;

-(nonnull instancetype) initWithCompare:(BOOL (^)(STStoryTeller *storyTeller, id key)) compareBlock {
    self = [super init];
    if (self) {
        _compareBlock = compareBlock;
    }
    return self;
}

-(BOOL) storyTeller:(STStoryTeller *) storyTeller matches:(id) key {
    return _compareBlock(storyTeller, key)
    && (self.nextMatcher == nil ? YES : [self.nextMatcher storyTeller:storyTeller matches:key]);
}

@end

NS_ASSUME_NONNULL_END
