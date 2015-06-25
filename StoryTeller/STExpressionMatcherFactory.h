//
//  STExpressionMatcherFactory.h
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STLogExpressionParserDelegate.h"

@interface STExpressionMatcherFactory : NSObject<STLogExpressionParserDelegate>
-(id) parseExpression:(NSString *) expression;
@end
