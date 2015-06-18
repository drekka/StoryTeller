//
//  STScribe.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;

/**
 A protocol that classes which produce output must implement.
 */
@protocol STScribe <NSObject>

-(void) writeMessage:(NSString *) message
          fromMethod:(const char *) methodName
          lineNumber:(int) lineNumber;

@end
