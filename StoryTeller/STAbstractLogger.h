//
//  STAbstractScribe.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import <StoryTeller/STLogger.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An abstract class that implements the core logic for formatting and writing text to output destinations.
 */
@interface STAbstractLogger : NSObject<STLogger>

/**
 Writes the passed text to the output.

 @discussion This method **MUST** be overridden.

 @param text the text to be written.
 */
-(void) writeText:(const char *) text;

@end

NS_ASSUME_NONNULL_END