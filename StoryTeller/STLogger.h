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
@protocol STLogger <NSObject>

@property (nonatomic, assign) BOOL showThreadId;
@property (nonatomic, assign) BOOL showThreadName;
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) BOOL showMethodDetails;

-(void) writeMessage:(NSString __nonnull *) message
          fromMethod:(const char __nonnull *) methodName
          lineNumber:(int) lineNumber;
@end
