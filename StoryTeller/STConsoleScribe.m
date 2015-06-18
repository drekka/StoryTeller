//
//  STConsoleScribe.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STConsoleScribe.h"

@implementation STConsoleScribe

-(void) writeMessage:(id)message fromMethod:(const char *)methodName lineNumber:(int)lineNumber {
    NSLog(@"%s %i %@", methodName, lineNumber, message);
}

@end
