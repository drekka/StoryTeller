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

-(void) processEOE {
    // strip trailing fence object.
    id topOfStack = POP();
    if (topOfStack != [NSNull null]) {
        PUSH(topOfStack);
    }
}


-(void) processClassToken {
    const char *classStr = POP_STR().UTF8String;
    Class refClass = objc_lookUpClass(classStr);
    if (refClass == NULL) {
        [self raise:[NSString stringWithFormat:@"Unknown class '%s'", classStr]];
    }
    PUSH(refClass);
    PUSH([NSNull null]);
}

-(void) processProtocolToken {
    const char *protocolStr = POP_STR().UTF8String;
    Protocol *refProtocol = objc_getProtocol(protocolStr);
    if (refProtocol == NULL) {
        [self raise:[NSString stringWithFormat:@"Unknown protocol '%s'", protocolStr]];
    }
    PUSH(refProtocol);
    PUSH([NSNull null]);
}

-(void) processKeyPathToken {
    NSArray *properties = ABOVE([NSNull null]);
    POP(); // Pop the null.
    PUSH([REV(properties) componentsJoinedByString:@"."]);
}

-(void) processPropertyToken {
    PUSH(POP_STR());
}

-(void) processOpToken {
    NSInteger tokenKind = POP_TOK().tokenKind;
    PUSH(@(tokenKind));
}

-(void) processValueToken {
    PKToken *token = POP_TOK();
    PUSH(token.tokenType == PKTokenTypeQuotedString ? token.quotedStringValue : token.value);
}

@end
