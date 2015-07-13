//
//  STConsoleScribe.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <StoryTeller/STConsoleLogger.h>

#define XCODE_COLORS_ESCAPE "\033["
#define XCODE_COLORS_SET_TEMPLATE @"%s%s%i,%i,%i;"
#define XCODE_COLORS_RESET     @XCODE_COLORS_ESCAPE ";"   // Clear any foreground or background color

NS_ASSUME_NONNULL_BEGIN

@implementation STConsoleLogger {
    int _detailsR, _detailsG, _detailsB;
    int _messageR, _messageG, _messageB;
    NSString *_originalLineTemplate;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        self.detailsColour = [UIColor lightGrayColor];
        self.messageColour = [UIColor blackColor];

        [[NSProcessInfo processInfo].environment enumerateKeysAndObjectsUsingBlock:^(NSString * __nonnull key, NSString * __nonnull obj, BOOL * __nonnull stop) {
            NSLog(@">>>>> %@ = %@", key, obj)
            ;        }];


        // CHeck for xcode colours.
        char *xcode_colors = getenv("XcodeColors");
        [self setAddXcodeColours:xcode_colors && (strcmp(xcode_colors, "YES") == 0) ];
    }
    return self;
}

-(void) setAddXcodeColours:(BOOL)addXcodeColours {
    _addXcodeColours = addXcodeColours;
    // rescan the template as ranges may have changed.
    self.lineTemplate = _originalLineTemplate;
}

-(void) setDetailsColour:(UIColor *)detailsColour {
    _detailsColour = detailsColour;
    [self setRed:&_detailsR green:&_detailsG blue:&_detailsB fromColour:detailsColour];
}

-(void) setMessageColour:(UIColor *)messageColour {
    _messageColour = messageColour;
    [self setRed:&_messageR green:&_messageG blue:&_messageB fromColour:messageColour];
}

-(void) setRed:(int *) redVariable
         green:(int *) greenVariable
          blue:(int *) blueVariable
    fromColour:(UIColor *) sourceColour {
    CGFloat r, g, b;
    [sourceColour getRed:&r green:&g blue:&b alpha:NULL];
    *redVariable = (int)(r * 255.0);
    *greenVariable = (int)(g * 255.0);
    *blueVariable = (int)(b * 255.0);

    // rescan the template as ranges may have changed.
    self.lineTemplate = _originalLineTemplate;
}

-(void) setLineTemplate:(NSString * __nonnull)lineTemplate {

    _originalLineTemplate = lineTemplate;

    if (!_addXcodeColours) {
        [super setLineTemplate:lineTemplate];
        return;
    }

    // Figure out where the message is.
    NSMutableString *colourizedLineTemplate = [lineTemplate mutableCopy];
    NSRange messageRange = [colourizedLineTemplate rangeOfString:STLoggerTemplateKeyMessage];

    // Build colour strings.
    NSString *messageColour = [NSString stringWithFormat:XCODE_COLORS_SET_TEMPLATE, XCODE_COLORS_ESCAPE, "fg", _messageR, _messageG, _messageB];
    NSString *detailsColour = [NSString stringWithFormat: XCODE_COLORS_SET_TEMPLATE, XCODE_COLORS_ESCAPE, "fg", _detailsR, _detailsG, _detailsB];

    NSString *newMsg = [NSString stringWithFormat:@"%@%@%@", messageColour, STLoggerTemplateKeyMessage, detailsColour];
    [colourizedLineTemplate replaceCharactersInRange:messageRange withString:newMsg];

    [super setLineTemplate:[NSString stringWithFormat:@"%@%@%@", detailsColour, colourizedLineTemplate, XCODE_COLORS_RESET]];
}

-(NSString *) lineTemplate {
    return _originalLineTemplate;
}

-(void) writeText:(const char __nonnull *) text {
    printf("%s", text);
}

NS_ASSUME_NONNULL_END

@end
