//
//  STFilterMatcher.h
//  StoryTeller
//
//  Created by Derek Clarkson on 26/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STMatcher.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A matcher implementation that can be used to change the value of the key being checked. 
 
 @discussion It works by calling a block that takes in the current key and returns a new key to be passed to the next matcher in the chain.
 */
@interface STFilterMatcher : NSObject<STMatcher>

/**
 The next matcher in the chain.
 */
@property (nonatomic, strong) id<STMatcher> nextMatcher;

/**
 Default initializer.

 @param filterBlock a block that returns YES if the logging key should be passed

 @return an instance of this class.
 */
-(instancetype) initWithFilter:(id (^)(id key)) filterBlock;

@end

NS_ASSUME_NONNULL_END
