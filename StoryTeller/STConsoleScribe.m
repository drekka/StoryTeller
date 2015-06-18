//
//  STConsoleScribe.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STConsoleScribe.h"
#import <pthread/pthread.h>

@implementation STConsoleScribe

-(void) writeMessage:(id __nonnull) message {
    printf("%s\n", [message UTF8String]);
}

@end
