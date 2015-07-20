//
//  STMatcherFactory.h
//  StoryTeller
//
//  Created by Derek Clarkson on 10/07/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface STMatcherFactory : NSObject

+(id<STMatcher>) isaClassMatcher:(Class) expected;

+(id<STMatcher>) isKindOfClassMatcher:(Class) expected;

+(id<STMatcher>) isNotKindOfClassMatcher:(Class) expected;

+(id<STMatcher>) conformsToProtocolMatcher:(Protocol *) expected;

+(id<STMatcher>) notConformsToProtocolMatcher:(Protocol *) expected;

+(id<STMatcher>) eqStringMatcher:(NSString *) expected;

+(id<STMatcher>) neStringMatcher:(NSString *) expected;

+(id<STMatcher>) eqNumberMatcher:(NSNumber *) expected;

+(id<STMatcher>) neNumberMatcher:(NSNumber *) expected;

+(id<STMatcher>) gtNumberMatcher:(NSNumber *) expected;

+(id<STMatcher>) geNumberMatcher:(NSNumber *) expected;

+(id<STMatcher>) ltNumberMatcher:(NSNumber *) expected;

+(id<STMatcher>) leNumberMatcher:(NSNumber *) expected;

+(id<STMatcher>) isTrueMatcher;

+(id<STMatcher>) isFalseMatcher;

+(id<STMatcher>) eqNilMatcher;

+(id<STMatcher>) neNilMatcher;

#pragma mark - Filters

+(id<STMatcher>) keyPathFilter:(NSString *) keypath;

@end

NS_ASSUME_NONNULL_END