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
#import "STCompareMatcher.h"
#import "STFilterMatcher.h"

@implementation STExpressionMatcherFactory {
    id<STMatcher> _matcher;
    NSInteger _op;
    id<STMatcher> _valueMatcher;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

-(nullable id<STMatcher>) parseExpression:(NSString __nonnull *) expression
                                    error:(NSError *__autoreleasing  __nullable * __nullable) error {

    STLogExpressionParser *parser = [[STLogExpressionParser alloc] initWithDelegate:self];

    // Finish matching.
    id<STMatcher> initialMatcher = nil;
    if ([parser parseString:expression error:error] == nil) {
        // Didn't parse. Nothing to do.
    } else if (_matcher == nil) {
        // Must be a single value
        initialMatcher = _valueMatcher;
    } else {
        // More complex expression. Here we should have a class and keypath.
        _matcher.nextMatcher.nextMatcher = _valueMatcher;
        initialMatcher = _matcher;
    }

    [self reset];
    return initialMatcher;
}

-(void) reset {
    _matcher = nil;
    _valueMatcher = nil;
    _op = STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ;
}

#pragma mark - Delegate methods

-(void) parser:(PKParser __nonnull *) parser didMatchProtocol:(PKAssembly __nonnull *) assembly {

    NSString *protocolName = [parser popString];
    Protocol *protocol = objc_getProtocol(protocolName.UTF8String);
    if (protocol == NULL) {
        [parser raise:[NSString stringWithFormat:@"Unable to find protocol %@", protocolName]];
        return;
    }
    _matcher = [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
        return [key conformsToProtocol:protocol];
    }];
}

-(void) parser:(PKParser __nonnull *) parser didMatchClass:(PKAssembly __nonnull *) assembly {

    NSString *className = [parser popString];
    Class class = objc_lookUpClass(className.UTF8String);
    if (class == NULL) {
        [parser raise:[NSString stringWithFormat:@"Unable to find class %@", className]];
        return;
    }

    _matcher = [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
        return [key isKindOfClass:class];
    }];
}

-(void) parser:(PKParser __nonnull *) parser didMatchString:(PKAssembly __nonnull *) assembly {
    PKToken *token = [parser popToken];
    NSString *expected = token.tokenKind == TOKEN_KIND_BUILTIN_QUOTEDSTRING ? token.quotedStringValue : token.value;
    _valueMatcher = [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
        return [expected isEqualToString:key];
    }];
}

-(void) parser:(PKParser __nonnull *) parser didMatchNumber:(PKAssembly __nonnull *) assembly {

    PKToken *token = [parser popToken];
    NSNumber *expected = token.value;
    _valueMatcher =  [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
        NSNumber *actual = (NSNumber *) key;
        switch (self->_op) {
            case STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ:
                return [actual compare:expected] == NSOrderedSame;

            case STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM:
                return [actual compare:expected] > NSOrderedSame;

            case STLOGEXPRESSIONPARSER_TOKEN_KIND_GE:
                return [actual compare:expected] >= NSOrderedSame;

            case STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM:
                return [actual compare:expected] <= NSOrderedSame;

            case STLOGEXPRESSIONPARSER_TOKEN_KIND_LE:
                return [actual compare:expected] < NSOrderedSame;

            default:
                // NE
                return [actual compare:expected] != NSOrderedSame;
        }
    }];
}

-(void) parser:(PKParser __nonnull *) parser didMatchBooleanTrue:(PKAssembly __nonnull *) assembly {
    [self parser:parser didMatchBoolean:YES];
}

-(void) parser:(PKParser __nonnull *) parser didMatchBooleanFalse:(PKAssembly __nonnull *) assembly {
    [self parser:parser didMatchBoolean:NO];
}

-(void) parser:(PKParser __nonnull *) parser didMatchBoolean:(BOOL) expected {
    [parser popToken];
    if (_op == STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ || _op == STLOGEXPRESSIONPARSER_TOKEN_KIND_NE) {
        NSInteger blockOp = _op; // Gets around issues with values for blocks.
        _valueMatcher = [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
            return expected ==
            (blockOp == STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ ? ((NSNumber *) key).boolValue : ! ((NSNumber *) key).boolValue);
        }];
    } else {
        [parser raise:@"Invalid operator. Booleans can only accept '==' or '!=' operators."];
    }
}


-(void) parser:(PKParser __nonnull *) parser didMatchKeyPath:(PKAssembly __nonnull *) assembly {

    NSMutableArray *paths = [@[] mutableCopy];
    while (! [assembly isStackEmpty]) {
        [paths insertObject:[parser popString] atIndex:0];
    }

    NSString *keyPath = [paths componentsJoinedByString:@"."];

    // Assume that there is alreadly a class or protocol matcher.
    _matcher.nextMatcher = [[STFilterMatcher alloc] initWithFilter:^id(id  __nonnull key) {
        return [key valueForKeyPath:keyPath];
    }];
}

-(void) parser:(PKParser __nonnull *) parser didMatchOp:(PKAssembly __nonnull *) assembly {
    _op = [parser popToken].tokenKind;
}

@end
