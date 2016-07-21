//
//  STMatcherFactory.m
//  StoryTeller
//
//  Created by Derek Clarkson on 10/07/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import  ObjectiveC;
#import "STMatcherFactory.h"
#import "STCompareMatcher.h"
#import "STFilterMatcher.h"
#import "STStoryTeller.h"

NS_ASSUME_NONNULL_BEGIN

@implementation STMatcherFactory

static Class __protocolClass;

+(void) initialize {
    __protocolClass = objc_getClass("Protocol");
}

+(id<STMatcher>) allMatcher {
    id<STMatcher> matcher = [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return true;
    }];
    matcher.exclusive = YES;
    return matcher;
}

+(id<STMatcher>) rootMatcher {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return storyTeller.numberActiveScopes == 0;
    }];
}

+(id<STMatcher>) isaClassMatcher:(Class) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return object_isClass(key) && [(Class)key isSubclassOfClass:expected];
    }];
}

+(id<STMatcher>) isKindOfClassMatcher:(Class) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return object_isClass(key) ? [(Class)key isSubclassOfClass:expected] : [key isKindOfClass:expected];
    }];
}

+(id<STMatcher>) isNotKindOfClassMatcher:(Class) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return object_isClass(key) ? ! [(Class)key isSubclassOfClass:expected] : ! [key isKindOfClass:expected];
    }];
}

+(id<STMatcher>) conformsToProtocolMatcher:(Protocol *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key conformsToProtocol:expected];
    }];
}

+(id<STMatcher>) notConformsToProtocolMatcher:(Protocol *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return ! [key conformsToProtocol:expected];
    }];
}

+(id<STMatcher>) eqStringMatcher:(NSString *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key isKindOfClass:[NSString class]]
        && [expected isEqualToString:key];
    }];
}

+(id<STMatcher>) neStringMatcher:(NSString *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key isKindOfClass:[NSString class]]
        && ! [expected isEqualToString:key];
    }];
}

+(id<STMatcher>) eqNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] == NSOrderedSame;
    }];
}

+(id<STMatcher>) neNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] != NSOrderedSame;
    }];
}

+(id<STMatcher>) gtNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] < NSOrderedSame;
    }];
}

+(id<STMatcher>) geNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] <= NSOrderedSame;
    }];
}

+(id<STMatcher>) ltNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] > NSOrderedSame;
    }];
}

+(id<STMatcher>) leNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] >= NSOrderedSame;
    }];
}

+(id<STMatcher>) isTrueMatcher {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key isKindOfClass:[NSNumber class]] && [(NSNumber *)key boolValue];
    }];
}

+(id<STMatcher>) isFalseMatcher {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return [key isKindOfClass:[NSNumber class]] && ! [(NSNumber *)key boolValue];
    }];
}

+(id<STMatcher>) eqNilMatcher {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return key == nil;
    }];
}

+(id<STMatcher>) neNilMatcher {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(STStoryTeller *storyTeller, id  key) {
        return key != nil;
    }];
}

#pragma mark - Filters

+(id<STMatcher>) keyPathFilter:(NSString *) keypath {
    return [[STFilterMatcher alloc] initWithFilter:^id(STStoryTeller *storyTeller, id  key) {
        return [key valueForKeyPath:keypath];
    }];
}

@end

NS_ASSUME_NONNULL_END
