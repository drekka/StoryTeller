//
//  STAbstractScribe.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//
@import ObjectiveC;

#import <StoryTeller/STAbstractLogger.h>
#import <pthread/pthread.h>

@implementation STAbstractLogger {
    NSDateFormatter *_dateFormatter;
}

@synthesize showMethodDetails = _showMethodDetails;
@synthesize showThreadName = _showThreadName;
@synthesize showThreadId = _showThreadId;
@synthesize showTime = _showTime;
@synthesize showKey = _showKey;

static Class __protocolClass;

+(void) initialize {
    __protocolClass = objc_lookUpClass("Protocol");
}

-(instancetype) init {
    self = [super init];
    if (self) {
        self.showMethodDetails = YES;
        self.showThreadId = YES;
        self.showThreadName = YES;
        self.showTime = YES;
        self.showKey = NO;
    }
    return self;
}

-(void) writeMessage:(NSString __nonnull *) message
          fromMethod:(const char __nonnull *) methodName
          lineNumber:(int) lineNumber
                 key:(nonnull id) key {

    NSMutableString *finalMessage = [[NSMutableString alloc] init];
    if (_showTime) {
        if (_dateFormatter == nil) {
            _dateFormatter = [[NSDateFormatter alloc] init];
            _dateFormatter.dateFormat = @"HH:mm:ss.sss";
        }
        [finalMessage appendFormat:@"%@ ", [_dateFormatter stringFromDate:[NSDate date]]];
    }

    if (_showThreadId) {
        [finalMessage appendFormat:@"<%x> ", pthread_mach_thread_np(pthread_self())];
    }

    if (_showThreadName) {
        NSThread *currentThread = [NSThread currentThread];
        NSString *threadName = currentThread.name;
        if ([threadName length] > 0) {
            [finalMessage appendFormat:@"%@ ", threadName];
        }
    }

    if (_showKey) {
        if ([self keyIsClass:key]) {
            [finalMessage appendFormat:@"[c:%s] ", class_getName(key)];
        } else if ([self keyIsProtocol:key]) {
            [finalMessage appendFormat:@"[p:%s] ", protocol_getName(key)];
        } else {
            [finalMessage appendFormat:@"[%@] ", key];
        }
    }

    if (_showMethodDetails) {
        [finalMessage appendFormat:@"%s(%i) ", methodName, lineNumber];
    }

    [finalMessage appendString:message];
    [self writeMessage:finalMessage];
}

-(void) writeMessage:(NSString __nonnull *) message {
    [self doesNotRecognizeSelector:_cmd];
}


-(BOOL) keyIsClass:(id) key {
    return class_isMetaClass(object_getClass(key));
}

-(BOOL) keyIsProtocol:(id) key {
    return [key class] == __protocolClass;
}

@end
