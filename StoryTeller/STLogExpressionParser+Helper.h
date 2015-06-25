//
//  STLogExpressionParser+Helper.h
//  StoryTeller
//
//  Created by Derek Clarkson on 24/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STLogExpressionParser.h"

@interface STLogExpressionParser (Helper)

-(void) processClassToken;
-(void) processProtocolToken;
-(void) processKeyPathToken;
-(void) processPropertyToken;
-(void) processValueToken;
-(void) processOpToken;

@end
