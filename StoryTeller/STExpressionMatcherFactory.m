//
//  STExpressionMatcherFactory.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import ObjectiveC;
#import <PEGKit/PEGKit.h>

#import <StoryTeller/STStoryTeller.h>
#import "STExpressionMatcherFactory.h"

#import "STLogExpressionParser.h"
#import "STCompareMatcher.h"
#import "STFilterMatcher.h"

typedef NS_ENUM(NSUInteger, ValueType) {
    ValueTypeString,
    ValueTypeNumber,
    ValueTypeNil,
    ValueTypeBoolean,
    ValueTypeClass,
    ValueTypeProtocol
};

@implementation STExpressionMatcherFactory {
    id<STMatcher> _rootMatcher;
    NSInteger _op;
    id _value;
    ValueType _valueType;
}

-(void) reset {
    _rootMatcher = nil;
    _op = STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ;
    _value = nil;
}

-(nullable id<STMatcher>) parseExpression:(NSString __nonnull *) expression
                                    error:(NSError *__autoreleasing  __nullable * __nullable) error {

    [self reset];
    STLogExpressionParser *parser = [[STLogExpressionParser alloc] initWithDelegate:self];

    // Failed to parse or a non-matcher command was received.
    if ([parser parseString:expression error:error] == nil) {
        return nil;
    }
    return _rootMatcher;
}

#pragma mark - Logger control

-(void) parser:(PKParser * __nonnull)parser didMatchLogAll:(PKAssembly * __nonnull)assembly {
    [[STStoryTeller storyTeller] logAll];
}

-(void) parser:(PKParser * __nonnull)parser didMatchLogRoot:(PKAssembly * __nonnull)assembly {
    [[STStoryTeller storyTeller] logRoots];
}

#pragma mark - Expressions

-(void) parser:(PKParser * __nonnull)parser didMatchSingleKeyExpr:(PKAssembly * __nonnull)assembly {
    if (_valueType == ValueTypeNumber) {
        NSNumber *expected = _value;
        [self addMatcher:[[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
            return [key isKindOfClass:[NSNumber class]] && [expected compare:key] == NSOrderedSame;
        }]];
    } else {
        NSString *expected = _value;
        [self addMatcher:[[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
            return [key isKindOfClass:[NSString class]] && [expected isEqualToString:key];
        }]];
    }
}

-(void) parser:(PKParser * __nonnull)parser didMatchRuntimeExpr:(PKAssembly * __nonnull)assembly {
    [self addMatcher:[self runtimeMatcherFromValue]];
}

-(void) parser:(PKParser __nonnull *) parser didMatchObjectType:(PKAssembly __nonnull *) assembly {
    [self addMatcher:[self objectTypeMatcherFromValue]];
}

-(void) parser:(PKParser __nonnull *) parser didMatchKeyPath:(PKAssembly __nonnull *) assembly {

    NSMutableArray *paths = [@[] mutableCopy];
    while (! [assembly isStackEmpty]) {
        [paths insertObject:[parser popString] atIndex:0];
    }

    NSString *keyPath = [paths componentsJoinedByString:@"."];
    [self addMatcher:[[STFilterMatcher alloc] initWithFilter:^id(id  __nonnull key) {
        return [key valueForKeyPath:keyPath];
    }]];
}

-(void) parser:(PKParser __nonnull *) parser didMatchNumericCmp:(PKAssembly __nonnull *) assembly {

    BOOL (^comparison) (NSNumber *n1, NSNumber *n2);
    switch (_op) {
        case STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ:
            comparison = ^BOOL(NSNumber *n1, NSNumber *n2) {
                return [n1 compare:n2] == NSOrderedSame;
            };
            break;

        case STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM:
            comparison = ^BOOL(NSNumber *n1, NSNumber *n2) {
                return [n1 compare:n2] > NSOrderedSame;
            };
            break;

        case STLOGEXPRESSIONPARSER_TOKEN_KIND_GE:
            comparison = ^BOOL(NSNumber *n1, NSNumber *n2) {
                return [n1 compare:n2] >= NSOrderedSame;
            };
            break;

        case STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM:
            comparison = ^BOOL(NSNumber *n1, NSNumber *n2) {
                return [n1 compare:n2] < NSOrderedSame;
            };
            break;

        case STLOGEXPRESSIONPARSER_TOKEN_KIND_LE:
            comparison = ^BOOL(NSNumber *n1, NSNumber *n2) {
                return [n1 compare:n2] <= NSOrderedSame;
            };
            break;

        default:
            // NE
            comparison = ^BOOL(NSNumber *n1, NSNumber *n2) {
                return [n1 compare:n2] != NSOrderedSame;
            };
            break;
    }

    NSNumber *expected = _value;
    [self addMatcher:[[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
        return [key isKindOfClass:[NSNumber class]] && comparison((NSNumber *) key, expected);
    }]];
}

-(void) parser:(PKParser __nonnull *) parser didMatchRuntimeCmp:(PKAssembly __nonnull *) assembly {
    if (_op == STLOGEXPRESSIONPARSER_TOKEN_KIND_IS) {
        [self addMatcher:[self runtimeMatcherFromValue]];
    } else {
        [self addMatcher:[self objectTypeMatcherFromValue]];
    }
}

-(void) parser:(PKParser __nonnull *) parser didMatchObjectCmp:(PKAssembly __nonnull *) assembly {

    // Use the op to decide the expected true/false result.
    BOOL expectedResult = _op == STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ;

    switch (_valueType) {
        case ValueTypeBoolean: {
            BOOL expected = ((NSNumber *)_value).boolValue;
            [self addMatcher:[[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
                return [key isKindOfClass:[NSNumber class]] && (expected == ((NSNumber *) key).boolValue) == expectedResult;
            }]];
            break;
        }

        case ValueTypeNil:
            [self addMatcher:[[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
                return (key == nil) == expectedResult;
            }]];
            break;

        default: {
            NSString *expected = _value;
            [self addMatcher:[[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
                return [key isKindOfClass:[NSString class]] && [expected isEqualToString:key] == expectedResult;
            }]];
        }
    }
}

#pragma mark - Operators

-(void) parser:(PKParser __nonnull *) parser didMatchRuntimeOp:(PKAssembly __nonnull *) assembly {
    PKToken *token = [parser popToken];
    _op = token.tokenKind;
}

-(void) parser:(PKParser __nonnull *) parser didMatchMathOp:(PKAssembly __nonnull *) assembly {
    PKToken *token = [parser popToken];
    _op = token.tokenKind;
}

-(void) parser:(PKParser __nonnull *) parser didMatchLogicalOp:(PKAssembly __nonnull *) assembly {
    PKToken *token = [parser popToken];
    _op = token.tokenKind;
}

#pragma mark - Values

-(void) parser:(PKParser __nonnull *) parser didMatchString:(PKAssembly __nonnull *) assembly {
    _valueType = ValueTypeString;
    _value = [self stringFromToken:[parser popToken]];
}

-(void) parser:(PKParser __nonnull *) parser didMatchNumber:(PKAssembly __nonnull *) assembly {
    _valueType = ValueTypeNumber;
    _value = [parser popToken].value;
}

-(void) parser:(PKParser __nonnull *) parser didMatchNil:(PKAssembly __nonnull *) assembly {
    _valueType = ValueTypeNil;
    [parser popToken];
}

-(void) parser:(PKParser __nonnull *) parser didMatchBoolean:(PKAssembly __nonnull *) assembly {
    _valueType = ValueTypeBoolean;
    NSInteger tokenKind = [parser popToken].tokenKind;
    _value = @(tokenKind == STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE || tokenKind == STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER);
}

-(void) parser:(PKParser __nonnull *) parser didMatchClass:(PKAssembly __nonnull *) assembly {
    _valueType = ValueTypeClass;
    const char *name = [parser popString].UTF8String;
    _value = objc_lookUpClass(name);
    if (_value == NULL) {
        [parser raise:[NSString stringWithFormat:@"Unable to find a class called %s", name]];
    }
}

-(void) parser:(PKParser __nonnull *) parser didMatchProtocol:(PKAssembly __nonnull *) assembly {
    _valueType = ValueTypeProtocol;
    const char *name = [parser popString].UTF8String;
    _value = objc_getProtocol(name);
    if (_value == NULL) {
        [parser raise:[NSString stringWithFormat:@"Unable to find a protocol called %s", name]];
    }
}

#pragma mark - Internal

-(id<STMatcher>) runtimeMatcherFromValue {

    if (_valueType == ValueTypeClass) {
        Class expected = _value;
        return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
            return [(Class)key isSubclassOfClass:expected];
        }];
    }

    // Must be a protocol.
    Protocol *expected = _value;
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
        return expected == key;
    }];
}

-(id<STMatcher>) objectTypeMatcherFromValue {

    BOOL expectedValue = _op == STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ;

    if (_valueType == ValueTypeClass) {
        Class expected = _value;
        return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
            return [key isKindOfClass:expected] == expectedValue;
        }];
    }

    // Must be a protocol.
    Protocol *expected = _value;
    return [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
        return [key conformsToProtocol:expected] == expectedValue;
    }];
}


-(void) addMatcher:(id<STMatcher>) matcher {

    if (_rootMatcher == nil) {
        _rootMatcher = matcher;
        return;
    }

    id<STMatcher> lastMatcher = _rootMatcher;
    while (lastMatcher.nextMatcher != nil) {
        lastMatcher = lastMatcher.nextMatcher;
    }
    lastMatcher.nextMatcher = matcher;
}

-(NSString *) stringFromToken:(PKToken *) token {
    return token.tokenKind == TOKEN_KIND_BUILTIN_QUOTEDSTRING ? token.quotedStringValue : token.value;
}

@end
