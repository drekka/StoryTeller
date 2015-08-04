//
//  StoryTeller.h
//  StoryTeller
//
//  Created by Derek Clarkson on 22/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;

#import <StoryTeller/STLogger.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The main StoryTeller class.
 @discussion This class brings together all the configuration and processing for Story Teller. At the moment it's all in one class because it's not very big. Most of the functionality commonly needed is wrapped up in macros defined above.
 
 Story teller starts up as a singleton when the app loads. At that time it reads it's configuration and sets itself with default value. From that point on it can be accessed through the storyTeller access point.
 */
@interface STStoryTeller : NSObject

/// @name Class methods

/**
 Provides access to the Story teller singleton instance. 
 
 @discussion All interactions with Story Teller should go through this method.
 @return The main STStoryTeller instance.
 */
+(STStoryTeller *) storyTeller;

/// @name Debug

/**
 Reset the logging system and clears all set logging criteria.

 @discussion Used mostly for debugging and testing. Generally speaking you would not need to reset the logging system.
 */
-(void) reset;

/// @name Configuration

/**
 The current active logger.

 @discussion By defaul this is an instance of STConsoleLogger. However, you can create and set a different class as long as it conforms to the STLogger protocol.
 @see STLogger
 */
@property (nonatomic, strong) id<STLogger> logger;

/// If YES, every `STLog(...)` statement will be active and logging.
@property (nonatomic, assign, readonly, getter=isLoggingAll) BOOL logAll;

/// If YES, only top level `STLog(...)` statements will be logged.
@property (nonatomic, assign, readonly, getter=isLoggingRoots) BOOL logRoots;

/**
 Turns on logging of everything regardless of log settings.

 @discussion Again not something that would normally be turned on. But can be useful when debugging. Activating this will override any other logging settings.
 */
-(void) logAll;

/**
 Turns on logging of all top level log statements.

 @discussion Similar to logAll except that it only logs the top level log statements. Any statement which is inside an active Key Scope will be ignored. The main goal of this is to enable a semi-quick high level report of the data going through the app. Activating this will will override any logging criteria. But not logAll.
 */
-(void) logRoots;

#pragma mark - Activating logging

/**
 Start logging for the passed key.
 
 @discussion This is the main method to call to activate logging programmatically.

 @param keyExpression the key to log. @see the documentation for descriptions of what this key can be.
 */
-(void) startLogging:(NSString *) keyExpression;

#pragma mark - Stories

/**
 Starts a key Scope. 

 @discussion the Key will basically group any `STLog(...)` statements that occur after it's definition and until it goes out of scope. Scope follows the Objective-C scope rules in that it finishes at the end of the current function, loop or if statement. Basically when a locally declared variable would be dealloced.
 
 The major difference is that this scope also applies to any `STLog(...)` statements that are contained within methods called whilst the scope is active. This is the main purpose of this as it allows methods which do not have access to the key to be included in the logs when that key is being logged.
 
 @param key the key scope to activate.
 */
-(void) startScope:(id) key;

/**
 Removes a specific Key Scope.
 @discussion Normally you would not need to call this directly as @c StoryTeller::startScope: automatically removes the keys when the escope ends. In fact, by automatically calling this method.

 @param key the key Scope to de-activate.
*/
-(void) endScope:(id) key;

/// @name Querying

/**
 Returns the number of Key Scopes that are currently active.

 @discussion Usually used for debugging and testing of Story Teller itself.
 */
@property (nonatomic, assign, readonly) int numberActiveScopes;

/**
 Can be used to query if a Key Scope is active.
 @param key the key Scope to query.
 */
-(BOOL) isScopeActive:(id) key;

#pragma mark - Logging

/// @name Logging

/**
 The main method to be called to log a message in the current logger.
 
 @discussion This method also handled the descision making around whether to pass the message onto the current logger or not. If going ahead, it assembles the final message and passes it to the logger.
 
 @param key the key to log the message under.
 @param fileName the name of the file where the `STLog(...)` statement occurs.
 @param methodName the name of the method where the `STLog(...)` statement occurs.
 @param lineNumber the line number in the method where the `STLog(...)` statement occurs.
 @param messageTemplate a standard NSString format message.
 @param ... a list of values for the message template. This must be nil terminated
 */
-(void) record:(id) key
          file:(const char *) fileName
        method:(const char *) methodName
    lineNumber:(int) lineNumber
       message:(NSString *) messageTemplate, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Useful helper method which executes a block of code if the key is active.

 @discussion Mainly used for wrapping up lines of code that involve more than just logging statements.
 
 @param key the key which will control the execution of the block.
 @param block the block to execute. The key argument is the key that was checked.
 */
-(void) execute:(id) key block:(void (^)(id key)) block;

@end

NS_ASSUME_NONNULL_END

