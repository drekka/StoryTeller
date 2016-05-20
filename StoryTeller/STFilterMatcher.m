//
//  STFilterMatcher.m
//  StoryTeller
//
//  Created by Derek Clarkson on 26/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <StoryTeller/STFilterMatcher.h>

NS_ASSUME_NONNULL_BEGIN

@implementation STFilterMatcher {
    id (^_filterBlock)(id key);
}

@synthesize nextMatcher = _nextMatcher;

-(instancetype) initWithFilter:(id (^)(id key)) filterBlock {
    self = [super init];
    if (self) {
        _filterBlock = [filterBlock copy];
    }
    return self;
}

-(BOOL) matches:(nullable id) key {
    NSAssert(_nextMatcher != NULL, @"Must have a next matcher");
    return [self.nextMatcher matches:_filterBlock(key)];
}

@end

NS_ASSUME_NONNULL_END

