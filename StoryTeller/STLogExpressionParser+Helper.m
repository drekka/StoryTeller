//
//  STLogExpressionParser+Helper.m
//  StoryTeller
//
//  Created by Derek Clarkson on 24/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STLogExpressionParser+Helper.h"
#import <PEGKit/PEGKit.h>
@import ObjectiveC;

@implementation STLogExpressionParser (Helper)

-(void) processClassToken {
    [self processRuntimeToken:NO];
}

-(void) processProtocolToken {
    [self processRuntimeToken:YES];
}

-(void) processRuntimeToken:(BOOL) expectProtocol {
    const char *tokenName = POP_STR().UTF8String;
    id ref = expectProtocol ? objc_getProtocol(tokenName) : objc_lookUpClass(tokenName);
    if (ref == NULL) {
        [self raise:[NSString stringWithFormat:@"Unknown %@ '%s'", expectProtocol ? @"protocol" : @"class", tokenName]];
    }
    PUSH(ref);
    //self.fenceToken = ref;
}

-(void) processKeyPathToken {
    //PUSH([REV(ABOVE(self.fenceToken)) componentsJoinedByString:@"."]);
}

-(void) processPropertyToken {
    PUSH(POP_STR());
}

-(void) processOpToken {
    NSInteger tokenKind = POP_TOK().tokenKind;
    PUSH(@(tokenKind));
}

-(void) processValueToken {
    /*
    PKToken *token = POP_TOK();
    id tokenValue;
    switch (token.tokenKind) {
        case STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE:
        case STLOGEXPRESSIONPARSER_TOKEN_KIND_YES:
            tokenValue = @YES;
            break;

        case STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE:
        case STLOGEXPRESSIONPARSER_TOKEN_KIND_NO:
            tokenValue = @NO;
            break;

        default:
            tokenValue = token.tokenType == PKTokenTypeQuotedString ? token.quotedStringValue : token.value;
            break;
    }

    PUSH(tokenValue);
     */
}

@end
