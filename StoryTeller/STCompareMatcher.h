//
//  STGenericMatcher.h
//  StoryTeller
//
//  Created by Derek Clarkson on 26/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STMatcher.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A matcher that compares the current key with a value and matches if the compare block matches them.
 */
@interface STCompareMatcher : NSObject<STMatcher>

/**
 Default initializer.
 
 @param compareBlock The block that will be used to compare the key with a value.
 */
-(instancetype) initWithCompare:(BOOL (^)(id key)) compareBlock;

@end

NS_ASSUME_NONNULL_END
