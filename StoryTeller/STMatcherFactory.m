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

@implementation STMatcherFactory

static Class __protocolClass;

+(void) initialize {
    __protocolClass = objc_getClass("Protocol");
}

+(id<STMatcher>) isaClassMatcher:(Class) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [self isAClass:key] && [(Class)key isSubclassOfClass:expected];
    }];
}

+(id<STMatcher>) isKindOfClassMatcher:(Class) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [self isAClass:key] ? [(Class)key isSubclassOfClass:expected] : [key isKindOfClass:expected];
    }];
}

+(id<STMatcher>) isNotKindOfClassMatcher:(Class) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [self isAClass:key] ? ! [(Class)key isSubclassOfClass:expected] : ! [key isKindOfClass:expected];
    }];
}

+(id<STMatcher>) conformsToProtocolMatcher:(Protocol *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key conformsToProtocol:expected];
    }];
}

+(id<STMatcher>) notConformsToProtocolMatcher:(Protocol *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return ! [key conformsToProtocol:expected];
    }];
}

+(id<STMatcher>) eqStringMatcher:(NSString *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key isKindOfClass:[NSString class]]
        && [expected isEqualToString:key];
    }];
}

+(id<STMatcher>) neStringMatcher:(NSString *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key isKindOfClass:[NSString class]]
        && ! [expected isEqualToString:key];
    }];
}

+(id<STMatcher>) eqNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] == NSOrderedSame;
    }];
}

+(id<STMatcher>) neNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] != NSOrderedSame;
    }];
}

+(id<STMatcher>) gtNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] < NSOrderedSame;
    }];
}

+(id<STMatcher>) geNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] <= NSOrderedSame;
    }];
}

+(id<STMatcher>) ltNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] > NSOrderedSame;
    }];
}

+(id<STMatcher>) leNumberMatcher:(NSNumber *) expected {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key isKindOfClass:[NSNumber class]]
        && [expected compare:key] >= NSOrderedSame;
    }];
}

+(id<STMatcher>) isTrueMatcher {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key isKindOfClass:[NSNumber class]] && [(NSNumber *)key boolValue];
    }];
}

+(id<STMatcher>) isFalseMatcher {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return [key isKindOfClass:[NSNumber class]] && ! [(NSNumber *)key boolValue];
    }];
}

+(id<STMatcher>) eqNilMatcher {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return key == nil;
    }];
}

+(id<STMatcher>) neNilMatcher {
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nullable key) {
        return key != nil;
    }];
}

#pragma mark - Filters

+(id<STMatcher>) keyPathFilter:(NSString *) keypath {
    return [[STFilterMatcher alloc] initWithFilter:^id(id  __nullable key) {
        return [key valueForKeyPath:keypath];
    }];
}

#pragma mark - Internal

+(BOOL) isAClass:(id) value {
    return class_isMetaClass(object_getClass(value));
}

@end
