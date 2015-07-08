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
 A simple class that logs all message to the XCode console.
 */
@interface STConsoleLogger : STAbstractLogger

@property (nonatomic, assign) BOOL addXcodeColours;
@property (nonatomic, strong, nonnull) UIColor *lineDetailsColour;
@property (nonatomic, strong, nonnull) UIColor *messageColour;

@end
