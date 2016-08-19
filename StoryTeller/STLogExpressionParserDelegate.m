//
//  STLogExpressionParserDelegate.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import ObjectiveC;
@import PEGKit;

#import "STStoryTeller.h"
#import "STLogExpressionParserDelegate.h"

#import "STLogExpressionParser.h"
#import "STMatcherFactory.h"

#import "STInternalMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ValueType) {
    ValueTypeString,
    ValueTypeNumber,
    ValueTypeNil,
    ValueTypeBoolean,
    ValueTypeClass,
    ValueTypeProtocol
};

@implementation STLogExpressionParserDelegate {
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

-(id<STMatcher>) parseExpression:(NSString *) expression {

    STDebugLog(@"Parsing %@", expression);

    [self reset];
    STLogExpressionParser *parser = [[STLogExpressionParser alloc] initWithDelegate:self];

    NSError *error = nil;
    if (![parser parseString:expression error:&error]) {
        // Throw an exception.
        STDebugLog(@"!!!! Error %@", error);
        @throw [NSException exceptionWithName:@"StoryTellerParseException" reason:error.localizedFailureReason userInfo:nil];
    }

    return _rootMatcher;
}

#pragma mark - Logger control

-(void) parser:(PKParser *)parser didMatchLogAll:(PKAssembly *)assembly {
    STDebugLog(@" ... matched %@", assembly);
    [self addMatcher:[STMatcherFactory allMatcher]];
}

-(void) parser:(PKParser *)parser didMatchLogRoot:(PKAssembly *)assembly {
    STDebugLog(@" ... matched %@", assembly);
    [self addMatcher:[STMatcherFactory rootMatcher]];
}

#pragma mark - Expressions

-(void) parser:(PKParser *)parser didMatchSingleKeyExpr:(PKAssembly *)assembly {
    STDebugLog(@" ... matched %@", assembly);
    [self addMatcher:_valueType == ValueTypeNumber ? [STMatcherFactory eqNumberMatcher:_value] : [STMatcherFactory eqStringMatcher:_value]];
}

-(void) parser:(PKParser *) parser didMatchObjectType:(PKAssembly *) assembly {
    STDebugLog(@" ... matched %@", assembly);
    [self addMatcher:[self objectTypeMatcherFromValue]];
}

-(void) parser:(PKParser *) parser didMatchKeyPath:(PKAssembly *) assembly {

    STDebugLog(@" ... matched %@", assembly);

    NSMutableArray *paths = [@[] mutableCopy];
    while (! [assembly isStackEmpty]) {
        [paths insertObject:[parser popString] atIndex:0];
    }

    NSString *keyPath = [paths componentsJoinedByString:@"."];
    [self addMatcher:[STMatcherFactory keyPathFilter:keyPath]];
}

-(void) parser:(PKParser *) parser didMatchNumericCmp:(PKAssembly *) assembly {

    STDebugLog(@" ... matched %@", assembly);

    switch (_op) {
        case STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ:
            [self addMatcher:[STMatcherFactory eqNumberMatcher:_value]];
            break;

        case STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM:
            [self addMatcher:[STMatcherFactory gtNumberMatcher:_value]];
            break;

        case STLOGEXPRESSIONPARSER_TOKEN_KIND_GE:
            [self addMatcher:[STMatcherFactory geNumberMatcher:_value]];
            break;

        case STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM:
            [self addMatcher:[STMatcherFactory ltNumberMatcher:_value]];
            break;

        case STLOGEXPRESSIONPARSER_TOKEN_KIND_LE:
            [self addMatcher:[STMatcherFactory leNumberMatcher:_value]];
            break;

        default:
            // NE
            [self addMatcher:[STMatcherFactory neNumberMatcher:_value]];
            break;
    }

}

-(void) parser:(PKParser *)parser didMatchRuntimeCmp:(PKAssembly *)assembly {
    STDebugLog(@" ... matched %@", assembly);
    [self addMatcher:[STMatcherFactory isaClassMatcher:_value]];
}

-(void) parser:(PKParser *) parser didMatchObjectCmp:(PKAssembly *) assembly {

    STDebugLog(@" ... matched %@", assembly);

    // Use the op to decide the expected true/false result.
    BOOL isEqual = _op == STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ;

    switch (_valueType) {

        case ValueTypeClass:
            [self addMatcher:isEqual ? [STMatcherFactory isKindOfClassMatcher:_value] : [STMatcherFactory isNotKindOfClassMatcher:_value]];
            break;

        case ValueTypeProtocol:
            [self addMatcher:isEqual ? [STMatcherFactory conformsToProtocolMatcher:_value] : [STMatcherFactory notConformsToProtocolMatcher:_value]];
            break;

        case ValueTypeBoolean: {
            if (isEqual) {
                [self addMatcher:((NSNumber *)_value).boolValue ? [STMatcherFactory isTrueMatcher] : [STMatcherFactory isFalseMatcher]];
            } else {
                [self addMatcher:((NSNumber *)_value).boolValue ? [STMatcherFactory isFalseMatcher] : [STMatcherFactory isTrueMatcher]];
            }
            break;
        }

        case ValueTypeNil:
            [self addMatcher:isEqual ? [STMatcherFactory eqNilMatcher] : [STMatcherFactory neNilMatcher]];
            break;

        default: {
            [self addMatcher:isEqual ? [STMatcherFactory eqStringMatcher:_value] : [STMatcherFactory neStringMatcher:_value]];
        }
    }
}

#pragma mark - Operators

-(void) parser:(PKParser *) parser didMatchRuntimeOp:(PKAssembly *) assembly {
    STDebugLog(@" ... matched %@", assembly);
    PKToken *token = [parser popToken];
    _op = token.tokenKind;
}

-(void) parser:(PKParser *) parser didMatchMathOp:(PKAssembly *) assembly {
    STDebugLog(@" ... matched %@", assembly);
    PKToken *token = [parser popToken];
    _op = token.tokenKind;
}

-(void) parser:(PKParser *) parser didMatchLogicalOp:(PKAssembly *) assembly {
    STDebugLog(@" ... matched %@", assembly);
    PKToken *token = [parser popToken];
    _op = token.tokenKind;
}

#pragma mark - Values

-(void) parser:(PKParser *) parser didMatchString:(PKAssembly *) assembly {
    STDebugLog(@" ... matched %@", assembly);
    _valueType = ValueTypeString;
    _value = [self stringFromToken:[parser popToken]];
}

-(void) parser:(PKParser *) parser didMatchNumber:(PKAssembly *) assembly {
    STDebugLog(@" ... matched %@", assembly);
    _valueType = ValueTypeNumber;
    _value = [parser popToken].value;
}

-(void) parser:(PKParser *) parser didMatchNil:(PKAssembly *) assembly {
    STDebugLog(@" ... matched %@", assembly);
    _valueType = ValueTypeNil;
    [parser popToken];
}

-(void) parser:(PKParser *) parser didMatchBoolean:(PKAssembly *) assembly {
    STDebugLog(@" ... matched %@", assembly);
    _valueType = ValueTypeBoolean;
    NSInteger tokenKind = [parser popToken].tokenKind;
    _value = @(tokenKind == STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE || tokenKind == STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER);
}

-(void) parser:(PKParser *) parser didMatchClass:(PKAssembly *) assembly {
    STDebugLog(@" ... matched %@", assembly.description);
    _valueType = ValueTypeClass;
    NSString *fullName = [assembly.stack componentsJoinedByString:@"."];
    [assembly.stack removeAllObjects];
    _value = objc_lookUpClass(fullName.UTF8String);
    if (_value == NULL) {
        [parser raise:[NSString stringWithFormat:@"Unable to find a class called %@", fullName]];
    }
}

-(void) parser:(PKParser *) parser didMatchProtocol:(PKAssembly *) assembly {
    STDebugLog(@" ... matched %@", assembly);
    _valueType = ValueTypeProtocol;
    NSString *fullName = [assembly.stack componentsJoinedByString:@"."];
    [assembly.stack removeAllObjects];
    _value = objc_getProtocol(fullName.UTF8String);
    if (_value == NULL) {
        [parser raise:[NSString stringWithFormat:@"Unable to find a protocol called %@", fullName]];
    }
}

#pragma mark - Internal

-(id<STMatcher>) objectTypeMatcherFromValue {
    BOOL isEqual = _op == STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ;
    if (_valueType == ValueTypeClass) {
        return isEqual ? [STMatcherFactory isKindOfClassMatcher:_value] : [STMatcherFactory isNotKindOfClassMatcher:_value];
    }
    return isEqual ? [STMatcherFactory conformsToProtocolMatcher:_value] : [STMatcherFactory notConformsToProtocolMatcher:_value];
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

NS_ASSUME_NONNULL_END
