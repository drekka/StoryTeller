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

#define NBR_KEYS 8 // details + message.

NSString * const STLoggerTemplateKeyThreadId = @"{{threadId}}";
NSString * const STLoggerTemplateKeyFile = @"{{file}}";
NSString * const STLoggerTemplateKeyFunction = @"{{function}}";
NSString * const STLoggerTemplateKeyLine = @"{{line}}";
NSString * const STLoggerTemplateKeyThreadName = @"{{threadName}}";
NSString * const STLoggerTemplateKeyTime = @"{{time}}";
NSString * const STLoggerTemplateKeyKey = @"{{key}}";
NSString * const STLoggerTemplateKeyMessage = @"{{message}}";


typedef NS_ENUM(int, DetailsDisplay) {
    DetailsDisplayThreadId,
    DetailsDisplayFile,
    DetailsDisplayFuntion,
    DetailsDisplayLine,
    DetailsDisplayThreadName,
    DetailsDisplayTime,
    DetailsDisplayKey,
    DetailsDisplayMessage
};

@implementation STAbstractLogger {
    NSDateFormatter *_dateFormatter;
    NSMutableArray *_lineFragments;
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
        _dateFormatter.dateFormat = @"HH:mm:ss.sss";
        self.lineTemplate = [NSString stringWithFormat:@"%@ %@:%@ %@", STLoggerTemplateKeyTime, STLoggerTemplateKeyFunction, STLoggerTemplateKeyLine, STLoggerTemplateKeyMessage];
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
        if ([scanner scanString:STLoggerTemplateKeyThreadId intoString:nil]) {
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
                @throw [NSException exceptionWithName:@"StoryTeller" reason:[NSString stringWithFormat:@"Unknown log template keyword {{%@}}", keyword] userInfo:nil];
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

    [_lineFragments enumerateObjectsUsingBlock:^(id  _Nonnull fragment, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([fragment isKindOfClass:[NSNumber class]]) {
            char *text;
            switch (((NSNumber *)fragment).intValue) {

                case DetailsDisplayThreadId: {
                    asprintf(&text, "<%x>", pthread_mach_thread_np(pthread_self()));
                    [self writeText:(const char *)text];
                    break;
                }

                case DetailsDisplayFile: {
                    [self writeText:fileName];
                    break;
                }

                case DetailsDisplayFuntion: {
                    [self writeText:methodName];
                    break;
                }

                case DetailsDisplayLine: {
                    asprintf(&text, "%i", lineNumber);
                    [self writeText:text];
                    break;
                }

                case DetailsDisplayThreadName: {
                    NSString *threadName = [NSThread currentThread].name;
                    if ([threadName length] > 0) {
                        [self writeText:threadName.UTF8String];
                    }
                    break;
                }

                case DetailsDisplayTime: {
                    [self writeText:[self->_dateFormatter stringFromDate:[NSDate date]].UTF8String];
                    break;
                }

                case DetailsDisplayKey: {
                    if ([self keyIsClass:key]) {
                        asprintf(&text, "c:[%s]", class_getName(key));
                    } else if ([self keyIsProtocol:key]) {
                        asprintf(&text, "p:<%s>", protocol_getName(key));
                    } else {
                        text = (char *)[NSString stringWithFormat:@"k:%@", key].UTF8String;
                    }
                    [self writeText:text];
                    break;
                }

                default: { // Message
                    [self writeText:message.UTF8String];
                }
            }
        } else {
            // Text fragment so just write it
            [self writeText:((NSString *)fragment).UTF8String];
        }
    }];

    // Write a final line feed.
    [self writeText:"\n"];
}

-(void) writeText:(const char * _Nonnull) text {
    [self doesNotRecognizeSelector:_cmd];
}

-(BOOL) keyIsClass:(id) key {
    return class_isMetaClass(object_getClass(key));
}

-(BOOL) keyIsProtocol:(id) key {
    return [key class] == __protocolClass;
}

@end
