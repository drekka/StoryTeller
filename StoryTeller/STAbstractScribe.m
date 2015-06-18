//
//  STAbstractScribe.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STAbstractScribe.h"
#import <pthread/pthread.h>

@implementation STAbstractScribe {
    NSDateFormatter *_dateFormatter;
}

@synthesize showLineNumber = _showLineNumber;
@synthesize showMethodName = _showMethodName;
@synthesize showThreadName = _showThreadName;
@synthesize showThreadId = _showThreadId;
@synthesize showTime = _showTime;

-(instancetype) init {
    self = [super init];
    if (self) {
        self.showLineNumber = YES;
        self.showMethodName = YES;
        self.showThreadId = YES;
        self.showThreadName = YES;
        self.showTime = YES;
    }
    return self;
}

-(void) writeMessage:(id __nonnull) message
          fromMethod:(const char __nonnull *) methodName
          lineNumber:(int) lineNumber {

    NSMutableString *finalMessage = [[NSMutableString alloc] init];
    if (_showTime) {
        if (_dateFormatter == nil) {
            _dateFormatter = [[NSDateFormatter alloc] init];
            _dateFormatter.dateFormat = @"HH:mm:ss.sss";
        }
        [finalMessage appendFormat:@"%@ ", [_dateFormatter stringFromDate:[NSDate date]]];
    }

    if (_showThreadId) {
        [finalMessage appendFormat:@"%x ", pthread_mach_thread_np(pthread_self())];
    }

    if (_showThreadName) {
        NSString *threadName = [NSThread currentThread].name;
        [finalMessage appendFormat:@"%@ ", threadName];
    }

    if (_showMethodName) {
        [finalMessage appendFormat:@"%s ", methodName];
    }

    if (_showLineNumber) {
        [finalMessage appendFormat:@"[%i] ", lineNumber];
    }

    [self writeMessage:finalMessage];
}

-(void) writeMessage:(NSString *) message {
    [self doesNotRecognizeSelector:_cmd];
}

@end
