//
//  STFilterMatcher.m
//  StoryTeller
//
//  Created by Derek Clarkson on 26/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STFilterMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@implementation STFilterMatcher {
    id (^_filterBlock)(STStoryTeller *storyTeller, id key);
}

@synthesize nextMatcher = _nextMatcher;
@synthesize exclusive = _exclusive;

-(instancetype) initWithFilter:(id (^)(STStoryTeller *storyTeller, id key)) filterBlock {
    self = [super init];
    if (self) {
        _filterBlock = [filterBlock copy];
    }
    return self;
}

-(BOOL) storyTeller:(STStoryTeller *) storyTeller matches:(id) key {
    NSAssert(_nextMatcher != NULL, @"Must have a next matcher");
    return [self.nextMatcher storyTeller:storyTeller matches:_filterBlock(storyTeller, key)];
}

@end

NS_ASSUME_NONNULL_END

