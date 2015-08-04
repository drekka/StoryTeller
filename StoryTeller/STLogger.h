//
//  STScribe.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const STLoggerTemplateKeyThreadId;
extern NSString * const STLoggerTemplateKeyFile;
extern NSString * const STLoggerTemplateKeyFunction;
extern NSString * const STLoggerTemplateKeyLine;
extern NSString * const STLoggerTemplateKeyThreadName;
extern NSString * const STLoggerTemplateKeyTime;
extern NSString * const STLoggerTemplateKeyKey;
extern NSString * const STLoggerTemplateKeyMessage;

/**
 Defines the public interface of classes which can act as loggers.
 */
@protocol STLogger <NSObject>

/**
 A NSString stringWithFormat: template which defines the format of each log line.
 */
@property (nonatomic, strong) NSString *lineTemplate;

/**
 Tells the logger to write the passed string.
 @discussion This is the main method to call in order to write to the log. The calling class is responsible for deciding whether to call this or not.
 @param message the string to be written to the output.
 @param fileName the name of the file which triggered this call.
 @param methodName the name of the method which triggered this call.
 @param lineNumber the line number in the method which triggered this call.
 @param key the key to log under.
 */
-(void) writeMessage:(NSString *) message
            fromFile:(const char *) fileName
          fromMethod:(const char *) methodName
          lineNumber:(int) lineNumber
                 key:(id) key;
@end

NS_ASSUME_NONNULL_END