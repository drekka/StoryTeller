//
//  STExpressionMatcherFactory.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import ObjectiveC;
#import <PEGKit/PEGKit.h>

#import "STExpressionMatcherFactory.h"

#import "STLogExpressionParser.h"

#import "STCLassMatcher.h"
#import "STProtocolMatcher.h"

@implementation STExpressionMatcherFactory {
    STLogExpressionParser *_parser;
    id<STMatcher> _matcher;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _parser = [[STLogExpressionParser alloc] initWithDelegate:self];
    }
    return self;
}

-(nullable id<STMatcher>) parseExpression:(NSString __nonnull *) expression
                                    error:(NSError *__autoreleasing  __nullable * __nullable) error {
    if ([_parser parseString:expression error:error] == nil) {
        // Didn't parse.
        return nil;
    }
    return _matcher;
}

#pragma mark - Delegate methods

-(void) parser:(PKParser __nonnull *) parser didMatchProtocol:(PKAssembly __nonnull *) assembly {
    NSString *protocolName = [parser popString];
    Protocol *protocol = objc_getProtocol(protocolName.UTF8String);
    if (protocol == NULL) {
        [parser raise:[NSString stringWithFormat:@"Unable to find protocol %@", protocolName]];
        return;
    }
    _matcher = [[STProtocolMatcher alloc] initWithProtocol:protocol];
}

-(void) parser:(PKParser __nonnull *) parser didMatchClass:(PKAssembly __nonnull *) assembly {
    NSString *className = [parser popString];
    Class class = objc_lookUpClass(className.UTF8String);
    if (class == NULL) {
        [parser raise:[NSString stringWithFormat:@"Unable to find class %@", className]];
        return;
    }
    _matcher = [[STClassMatcher alloc] initWithClass:class];
}

-(void) parser:(PKParser __nonnull *) parser didMatchValue:(PKAssembly __nonnull *) assembly {

}

-(void) parser:(PKParser __nonnull *) parser didMatchKeyPath:(PKAssembly __nonnull *) assembly {

}
-(void) parser:(PKParser __nonnull *) parser didMatchOp:(PKAssembly __nonnull *) assembly {

}


@end
