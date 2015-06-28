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

@implementation STExpressionMatcherFactory {
    id<STMatcher> _matcher;
    NSInteger _op;
    id<STMatcher> _valueMatcher;
    BOOL _runtimeQuery;
    BOOL _optionSet;
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
        // Didn't parse or something that doesn't return a matcher.
        [self reset];
        return nil;
    }

    // If log options have been set, return a nil
    if (_optionSet) {
        [self reset];
        return nil;
    }

    // Add the matcher.
    if (_matcher == nil) {
        // Must be a single value
        initialMatcher = _valueMatcher;
    } else {
        // More complex expression. Here we should have a class and keypath.
        initialMatcher = _matcher;
        initialMatcher.nextMatcher.nextMatcher = _valueMatcher;
    }

    [self reset];
    return initialMatcher;
}

-(void) reset {
    _matcher = nil;
    _valueMatcher = nil;
    _optionSet = NO;
    _op = STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ;
}

#pragma mark - Delegate methods

-(void) parser:(PKParser * __nonnull)parser didMatchLogAll:(PKAssembly * __nonnull)assembly {
    [parser popToken];
    [[STStoryTeller storyTeller] logAll];
    _optionSet = YES;
}

-(void) parser:(PKParser * __nonnull)parser didMatchLogRoot:(PKAssembly * __nonnull)assembly {
    [parser popToken];
    [[STStoryTeller storyTeller] logRoot];
    _optionSet = YES;
}

-(void) parser:(PKParser __nonnull *) parser didMatchIsa:(PKAssembly __nonnull *) assembly {
    [parser popToken];
    _runtimeQuery = YES;
}

-(void) parser:(PKParser __nonnull *) parser didMatchProtocol:(PKAssembly __nonnull *) assembly {
    [self parser:parser
        didMatch:@"protocol"
     lookupBlock:^id(const char * __nonnull objName) {
         return objc_getProtocol(objName);
     }
      checkBlock:^BOOL(id __nonnull key, id __nonnull rtObj) {
          return [key conformsToProtocol:rtObj];
      }];
}

-(void) parser:(PKParser __nonnull *) parser didMatchClass:(PKAssembly __nonnull *) assembly {
    [self parser:parser
        didMatch:@"class"
     lookupBlock:^id(const char * __nonnull objName) {
         return objc_lookUpClass(objName);
     }
      checkBlock:^BOOL(id __nonnull key, id __nonnull rtObj) {
          return [key isKindOfClass:rtObj];
      }];
}

-(void) parser:(PKParser __nonnull *) parser didMatch:(NSString __nonnull *) type lookupBlock:(id (^ __nonnull)(const char * __nonnull objName)) lookupBlock checkBlock:(BOOL (^ __nonnull)(id __nonnull key, id __nonnull rtObj)) checkBlock {

    NSString *rtObjName = [parser popString];
    id rtObj = lookupBlock(rtObjName.UTF8String);
    if (rtObj == NULL) {
        [parser raise:[NSString stringWithFormat:@"Unable to find %@ %@", type, rtObjName]];
        return;
    }

    BOOL useEquals = _runtimeQuery;
    _matcher = [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
        return useEquals ? key == rtObj : checkBlock(key, rtObj);
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
    NSInteger op = _op;
    _valueMatcher =  [[STCompareMatcher alloc] initWithCompare:^BOOL(id  __nonnull key) {
        NSNumber *actual = (NSNumber *) key;
        switch (op) {
            case STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ:
                return [actual compare:expected] == NSOrderedSame;

            case STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM:
                return [actual compare:expected] > NSOrderedSame;

            case STLOGEXPRESSIONPARSER_TOKEN_KIND_GE:
                return [actual compare:expected] >= NSOrderedSame;

            case STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM:
                return [actual compare:expected] < NSOrderedSame;

            case STLOGEXPRESSIONPARSER_TOKEN_KIND_LE:
                return [actual compare:expected] <= NSOrderedSame;

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
