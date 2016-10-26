//
//  STAbstractScribe.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//
@import ObjectiveC;

#import "STAbstractLogger.h"
#import <pthread/pthread.h>

NSString * const STLoggerTemplateKeyThreadPicture = @"{{threadPicture}}";
NSString * const STLoggerTemplateKeyThreadNumber = @"{{threadNumber}}";
NSString * const STLoggerTemplateKeyThreadId = @"{{threadId}}";
NSString * const STLoggerTemplateKeyFile = @"{{file}}";
NSString * const STLoggerTemplateKeyFunction = @"{{function}}";
NSString * const STLoggerTemplateKeyLine = @"{{line}}";
NSString * const STLoggerTemplateKeyThreadName = @"{{threadName}}";
NSString * const STLoggerTemplateKeyTime = @"{{time}}";
NSString * const STLoggerTemplateKeyKey = @"{{key}}";
NSString * const STLoggerTemplateKeyMessage = @"{{message}}";

typedef NS_ENUM(int, DetailsDisplay) {
    DetailsDisplayThreadPicture,
    DetailsDisplayThreadId,
    DetailsDisplayThreadNumber,
    DetailsDisplayFile,
    DetailsDisplayFuntion,
    DetailsDisplayLine,
    DetailsDisplayThreadName,
    DetailsDisplayTime,
    DetailsDisplayKey,
    DetailsDisplayMessage
};

NS_ASSUME_NONNULL_BEGIN

@implementation STAbstractLogger {
    NSDateFormatter *_dateFormatter;
    NSMutableArray *_lineFragments;
    BOOL _lastThreadWasMain;
}

@synthesize lineTemplate = _lineTemplate;

static Class __protocolClass;

+(void) initialize {
    __protocolClass = objc_lookUpClass("Protocol");
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"HH:mm:ss.SSS";
        self.lineTemplate = [NSString stringWithFormat:@"%@ %@:%@ %@", STLoggerTemplateKeyTime, STLoggerTemplateKeyFile, STLoggerTemplateKeyLine, STLoggerTemplateKeyMessage];
        _lastThreadWasMain = YES;
    }
    return self;
}

-(void) setLineTemplate:(NSString * _Nonnull) lineTemplate {
    
    if ([lineTemplate isEqualToString:_lineTemplate]) {
        return;
    }
    
    _lineFragments = [[NSMutableArray alloc] init];
    _lineTemplate = lineTemplate;
    
    // Get a scanner.
    NSScanner *scanner = [NSScanner scannerWithString:lineTemplate];
    scanner.charactersToBeSkipped = nil;
    do {
        if ([scanner scanString:STLoggerTemplateKeyThreadPicture intoString:nil]) {
            [_lineFragments addObject:@(DetailsDisplayThreadPicture)];
        } else if ([scanner scanString:STLoggerTemplateKeyThreadNumber intoString:nil]) {
            [_lineFragments addObject:@(DetailsDisplayThreadNumber)];
        } else if ([scanner scanString:STLoggerTemplateKeyThreadId intoString:nil]) {
            [_lineFragments addObject:@(DetailsDisplayThreadId)];
        } else if ([scanner scanString:STLoggerTemplateKeyFile intoString:nil]) {
            [_lineFragments addObject:@(DetailsDisplayFile)];
        } else if ([scanner scanString:STLoggerTemplateKeyFunction intoString:nil]) {
            [_lineFragments addObject:@(DetailsDisplayFuntion)];
        } else if ([scanner scanString:STLoggerTemplateKeyLine intoString:nil]) {
            [_lineFragments addObject:@(DetailsDisplayLine)];
        } else if ([scanner scanString:STLoggerTemplateKeyThreadName intoString:nil]) {
            [_lineFragments addObject:@(DetailsDisplayThreadName)];
        } else if ([scanner scanString:STLoggerTemplateKeyTime intoString:nil]) {
            [_lineFragments addObject:@(DetailsDisplayTime)];
        } else if ([scanner scanString:STLoggerTemplateKeyKey intoString:nil]) {
            [_lineFragments addObject:@(DetailsDisplayKey)];
        } else if ([scanner scanString:STLoggerTemplateKeyMessage intoString:nil]) {
            [_lineFragments addObject:@(DetailsDisplayMessage)];
        } else {
            
            // If the next two chars are the start chars
            // then we are stalled at the start of a keyword.
            // Must be unknown so error.
            if ([scanner scanString:@"{{" intoString:nil]) {
                NSString *keyword;
                if (![scanner scanUpToString:@"}}" intoString:&keyword]) {
                    keyword = [lineTemplate substringFromIndex:scanner.scanLocation];
                }
                @throw [NSException exceptionWithName:@"StoryTellerUnknownKeyword" reason:[NSString stringWithFormat:@"Unknown log template keyword {{%@}}", keyword] userInfo:nil];
            }
            
            // Must be some text so scan up to the next opening delimiters.
            NSString *text;
            if ([scanner scanUpToString:@"{{" intoString:&text]) {
                if (text.length > 0) {
                    [_lineFragments addObject:text];
                }
            } else {
                // No more keywords.
                [_lineFragments addObject:[lineTemplate substringFromIndex:scanner.scanLocation]];
                break;
            }
        }
        
    } while(!scanner.atEnd);
    
}

-(void) writeMessage:(NSString *) message
            fromFile:(const char *) fileName
          fromMethod:(const char *) methodName
          lineNumber:(int) lineNumber
                 key:(id) key {
    
    char *buffer = (char *) calloc(1, sizeof(char));
    char **bufferPtr = &buffer;
    [_lineFragments enumerateObjectsUsingBlock:^(id fragment, NSUInteger idx, BOOL *stop) {
        
        if ([fragment isKindOfClass:[NSNumber class]]) {
            switch (((NSNumber *)fragment).intValue) {
                    
                case DetailsDisplayThreadId: {
                    [self appendBuffer:bufferPtr chars:"<"];
                    [self appendBuffer:bufferPtr hex:(int) pthread_mach_thread_np(pthread_self())];
                    [self appendBuffer:bufferPtr chars:">"];
                    break;
                }
                    
                case DetailsDisplayThreadNumber: {
                    [self appendBuffer:bufferPtr chars:"<"];
                    [self appendBuffer:bufferPtr int:(int) pthread_mach_thread_np(pthread_self())];
                    [self appendBuffer:bufferPtr chars:">"];
                    break;
                }
                    
                case DetailsDisplayThreadName: {
                    NSString *threadName = [NSThread currentThread].name;
                    if ([threadName length] > 0) {
                        [self appendBuffer:bufferPtr string:threadName];
                    }
                    break;
                }
                    
                case DetailsDisplayThreadPicture: {
                    if ([NSThread isMainThread]) {
                        if (self->_lastThreadWasMain) {
                            [self appendBuffer:bufferPtr chars:"|  "];
                        } else {
                            [self appendBuffer:bufferPtr chars:"|¯ "];
                            self->_lastThreadWasMain = YES;
                        }
                    } else {
                        if (self->_lastThreadWasMain) {
                            [self appendBuffer:bufferPtr chars:"|¯]"];
                            self->_lastThreadWasMain = NO;
                        } else {
                            [self appendBuffer:bufferPtr chars:"| ]"];
                        }
                    }
                    break;
                }
                    
                case DetailsDisplayFile: {
                    NSString *lastPathComponent = [NSString stringWithCString:fileName encoding:NSUTF8StringEncoding].lastPathComponent;
                    [self appendBuffer:bufferPtr string:lastPathComponent];
                    break;
                }
                    
                case DetailsDisplayFuntion: {
                    [self appendBuffer:bufferPtr chars:methodName];
                    break;
                }
                    
                case DetailsDisplayLine: {
                    [self appendBuffer:bufferPtr int:lineNumber];
                    break;
                }
                    
                case DetailsDisplayTime: {
                    [self appendBuffer:bufferPtr string:[self->_dateFormatter stringFromDate:[NSDate date]]];
                    break;
                }
                    
                case DetailsDisplayKey: {
                    if (object_isClass(key)) {
                        [self appendBuffer:bufferPtr chars:"c:["];
                        [self appendBuffer:bufferPtr string:NSStringFromClass(key)];
                        [self appendBuffer:bufferPtr chars:"]"];
                    } else if ([self keyIsProtocol:key]) {
                        [self appendBuffer:bufferPtr chars:"p:<"];
                        [self appendBuffer:bufferPtr string:NSStringFromProtocol(key)];
                        [self appendBuffer:bufferPtr chars:">"];
                    } else {
                        [self appendBuffer:bufferPtr chars:"k:'"];
                        [self appendBuffer:bufferPtr string:[key description]];
                        [self appendBuffer:bufferPtr chars:"'"];
                    }
                    break;
                }
                    
                default: { // Message
                    [self appendBuffer:bufferPtr string:message];
                }
            }
            
        } else {
            // Text fragment so just write it
            [self appendBuffer:bufferPtr string:fragment];
        }
    }];
    
    // Write a final line feed.
    [self writeText:buffer];
    free(buffer);
    
}

-(void) appendBuffer:(char **) bufferPtr string:(NSString *) text {
    char *newBuffer;
    if (-1 == asprintf(&newBuffer, "%s%s", *bufferPtr, text.UTF8String)) {
        NSLog(@"Failed to concatinate '%s' and '%s', insufficent memory!", *bufferPtr, text.UTF8String);
    }
    free(*bufferPtr);
    *bufferPtr = newBuffer;
}

-(void) appendBuffer:(char **) buffer int:(int) aInt {
    char *oldBuffer = *buffer;
    if (-1 == asprintf(buffer, "%s%i", oldBuffer, aInt)) {
        NSLog(@"Failed to concatinate '%s' and '%i', insufficent memory!", oldBuffer, aInt);
    }
    free(oldBuffer);
}

-(void) appendBuffer:(char **) buffer hex:(int) aInt {
    char *oldBuffer = *buffer;
    if (-1 == asprintf(buffer, "%s%#x", oldBuffer, aInt)) {
        NSLog(@"Failed to concatinate '%s' and '%#x', insufficent memory!", oldBuffer, aInt);
    }
    free(oldBuffer);
}

-(void) appendBuffer:(char **) buffer chars:(const char *) text {
    char *oldBuffer = *buffer;
    if (-1 == asprintf(buffer, "%s%s", oldBuffer, text)) {
        NSLog(@"Failed to concatinate '%s' and '%s', insufficent memory!", oldBuffer, text);
    }
    free(oldBuffer);
}

-(void) writeText:(char *) text {
    [self doesNotRecognizeSelector:_cmd];
}

-(BOOL) keyIsProtocol:(id) key {
    return [key class] == __protocolClass;
}

@end

NS_ASSUME_NONNULL_END
