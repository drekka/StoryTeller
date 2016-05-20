//
//  STConsoleScribe.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <StoryTeller/STAbstractLogger.h>
@import UIKit;

/**
 Logs all message to the XCode console using printf.
 */
@interface STConsoleLogger : STAbstractLogger


/// Manually controls the addition of XcodeColors colour coding.
@property (nonatomic, assign) BOOL addXcodeColours;

/// The colour of text that is part of the details. Keys, dates, method signatures etc.
@property (nonatomic, strong, nonnull) UIColor *detailsColour;

/// The colour of the message part of the logged line.
@property (nonatomic, strong, nonnull) UIColor *messageColour;

@end
