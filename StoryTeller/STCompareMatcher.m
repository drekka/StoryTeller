//
//  STGenericMatcher.m
//  StoryTeller
//
//  Created by Derek Clarkson on 26/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <StoryTeller/STCompareMatcher.h>

@implementation STCompareMatcher {
    BOOL (^ _Nonnull _compareBlock)(_Nullable id key);
}

@synthesize nextMatcher = _nextMatcher;

-(nonnull instancetype) initWithCompare:(BOOL (^ _Nonnull)(_Nullable id key)) compareBlock {
    self = [super init];
    if (self) {
        _compareBlock = compareBlock;
    }
    return self;
}

-(BOOL) matches:(id _Nullable) key {
    return _compareBlock(key)
    && (self.nextMatcher == nil ? YES : [self.nextMatcher matches:key]);
}

@end
