//
//  STConsoleScribe.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <StoryTeller/STConsoleLogger.h>
#define XCODE_COLOURS_TEMPLATE @"\033[fg:%i,%i,%i; %@\n   \033[fg:%i,%i,%i;%@\033[;"

@implementation STConsoleLogger

-(nonnull instancetype) init {
    self = [super init];
    if (self) {
        _lineDetailsColour = [UIColor lightGrayColor];
        _messageColour = [UIColor blackColor];
    }
    return self;
}

-(void) writeDetails:(NSString * __nullable)details message:(NSString * __nonnull)message {
    NSString *finalString;
    if (_addXcodeColours) {
        CGFloat detailsR;
        CGFloat detailsG;
        CGFloat detailsB;
        CGFloat messageR;
        CGFloat messageG;
        CGFloat messageB;
        [_lineDetailsColour getRed:&detailsR green:&detailsG blue:&detailsB alpha:NULL];
        [_messageColour getRed:&messageR green:&messageG blue:&messageB alpha:NULL];
        finalString = [NSString stringWithFormat:XCODE_COLOURS_TEMPLATE, (int)(detailsR *255.0), (int)(detailsG *255.0), (int)(detailsB *255.0), details,
               (int)(messageR *255.0), (int)(messageG *255.0), (int)(messageB *255.0), message];
    } else {
        finalString = [details stringByAppendingString:message];
    }
    printf("%s\n", [finalString UTF8String]);
}

@end
