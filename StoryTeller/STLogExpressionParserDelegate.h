//
//  STLogExpressionParserDelegate.h
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;

@class STStoryTeller;
#import "STMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface STLogExpressionParserDelegate : NSObject

-(id<STMatcher>) parseExpression:(NSString *) expression
									error:(NSError * __autoreleasing  *) error;

@end

NS_ASSUME_NONNULL_END
