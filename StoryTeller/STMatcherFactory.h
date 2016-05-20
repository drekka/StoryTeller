//
//  STMatcherFactory.h
//  StoryTeller
//
//  Created by Derek Clarkson on 10/07/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import <StoryTeller/STMatcher.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A factory that generates matchers which can then be composed to a high speed implementation of the parsed log expression.
 */
@interface STMatcherFactory : NSObject

/**
 Returns a matcher that matches if the key if it's a specific class or a descendant of that class.
 
 @discussion This can also be used to match protocols by obtaining the class of the protocol and comparing against that.
 
 @param expected The class that should be matched against.

 @return An instance of the matcher.
 */
+(id<STMatcher>) isaClassMatcher:(Class) expected;

/**
 Returns a matcher that matches if the key is an instance of a class.

 @param expected The class we are going to check.

 @return An instance of the matcher.
 */
+(id<STMatcher>) isKindOfClassMatcher:(Class) expected;

/**
 Returns the opposite of the isKindOfClassMatcher:. In other words, where the key is not an instance of the class.

 @param expected The class to check.

 @return An instance of the matcher.
 */
+(id<STMatcher>) isNotKindOfClassMatcher:(Class) expected;

/**
 Returns a matcher that matches if the key conforms to a specific protocol.

 @param expected The protocol to check.

 @return An instance of the matcher.
 */
+(id<STMatcher>) conformsToProtocolMatcher:(Protocol *) expected;

/**
 Returns the opposite of conformsToProtocolMatcher:. In other words a matcher that matches if the key does not implement the expected protocol.

 @param expected The protocol to check against.

 @return An instance of the matcher.
 */
+(id<STMatcher>) notConformsToProtocolMatcher:(Protocol *) expected;

/**
 Returns a matcher that matches if the key is a expected value.

 @param expected The value to check against.

 @return An instance of the matcher.
 */
+(id<STMatcher>) eqStringMatcher:(NSString *) expected;

/**
 Returns a matcher that matches if the key is not equal to the expected value.

 @param expected The value to compare against.

 @return An instance of the matcher.
 */
+(id<STMatcher>) neStringMatcher:(NSString *) expected;

/**
 Returns a matcher than matches if the key is a number and equal to the expected value.

 @param expected An instance of NSNumber to check against.

 @return An instance of the matcher.
 */
+(id<STMatcher>) eqNumberMatcher:(NSNumber *) expected;

/**
 Returns a matcher than matches if the key is a number and not equal to the expected value.

 @param expected An instance of a NSNumber to check against.

 @return An instance of the matcher.
 */
+(id<STMatcher>) neNumberMatcher:(NSNumber *) expected;

/**
 Returns a matcher than matches if the key is a number and greater than to the expected value.

 @param expected An instance of NSNumber to check against.

 @return An instance of the matcher.
 */
+(id<STMatcher>) gtNumberMatcher:(NSNumber *) expected;

/**
 Returns a matcher than matches if the key is a number and greater than or equal to the expected value.

 @param expected An instance of NSNumber to check against.

 @return An instance of the matcher.
 */
+(id<STMatcher>) geNumberMatcher:(NSNumber *) expected;

/**
 Returns a matcher than matches if the key is a number and less than to the expected value.

 @param expected An instance of NSNumber to check against.

 @return An instance of the matcher.
 */
+(id<STMatcher>) ltNumberMatcher:(NSNumber *) expected;

/**
 Returns a matcher than matches if the key is a number and less than or equal to the expected value.

 @param expected An instance of NSNumber to check against.

 @return An instance of the matcher.
 */
+(id<STMatcher>) leNumberMatcher:(NSNumber *) expected;

/**
 Returns a matcher than matches if the key is an instance of NSNumber and it's boolean value is YES.

 @return An instance of the matcher.
 */
+(id<STMatcher>) isTrueMatcher;

/**
 Returns a matcher than matches if the key is an instance of NSNumber and it's boolean value is NO.

 @return An instance of the matcher.
 */
+(id<STMatcher>) isFalseMatcher;

/**
 Returns a matcher than matches if the key is nil.

 @return An instance of the matcher.
 */
+(id<STMatcher>) eqNilMatcher;

/**
 Returns a matcher than matches if the key is not nil.

 @return An instance of the matcher.
 */
+(id<STMatcher>) neNilMatcher;

#pragma mark - Filters

/**
 Returns a matcher than filters the key, using it as a key path to derive a new value before passing it to the next matcher.
 
 @param keypath The key path to use to obtain the new value.

 @return An instance of the matcher.
 */
+(id<STMatcher>) keyPathFilter:(NSString *) keypath;

@end

NS_ASSUME_NONNULL_END