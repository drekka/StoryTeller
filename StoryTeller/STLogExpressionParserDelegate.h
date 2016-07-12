//
//  STLogExpressionParserDelegate.h
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;

@protocol STMatcher;

NS_ASSUME_NONNULL_BEGIN

/**
 The delegate for the STLogExpressionParser class generated PEGKit.
 
 @discussion To receive information from the PEGKit parsing of a string, a class can receive messages via delegate calls. This class manages the parsing of a string containing a message and responding to the callbacks from PEGKit.
 */
@interface STLogExpressionParserDelegate : NSObject

/**
 Call to parse a string containing an expression and generate a STMatcher which can validate objects based on that expression.
 
 @param expression the expression to be parsed.
 */
-(id<STMatcher>) parseExpression:(NSString *) expression;

@end

NS_ASSUME_NONNULL_END
