//
//  STLogExpressionParserTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 24/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PEGKit/PEGKit.h>

#import "STLogExpressionParser.h"
#import "STLogExpressionParserDelegate.h"

typedef NS_OPTIONS(int, Matched) {
    MatchedValue = 1 << 0,
    MatchedClass = 1 << 1,
    MatchedProtocol = 1 << 2,
    MatchedOp = 1 << 3
};

@interface STLogExpressionParserTests : XCTestCase<STLogExpressionParserDelegate>

@end

@implementation STLogExpressionParserTests {
    int _matched;
    PKToken *_valueToken;
    PKToken *_classToken;
    PKToken *_protocolToken;
    NSString *_keyPath;
    PKToken *_opToken;
}

-(void) setUp {
    _matched = 0;
    _valueToken = nil;
    _classToken = nil;
    _protocolToken = nil;
    _keyPath = nil;
    _opToken = nil;
}


#pragma mark - Delegate methods

-(void) parser:(PKParser * __nonnull) parser didMatchClass:(PKAssembly * __nonnull) assembly {
    _matched += MatchedClass;
    _classToken = [parser popToken];
}

-(void) parser:(PKParser * __nonnull) parser didMatchProtocol:(PKAssembly * __nonnull) assembly {
    _matched += MatchedProtocol;
    _protocolToken = [parser popToken];
}

-(void) parser:(PKParser * __nonnull) parser didMatchValue:(PKAssembly * __nonnull) assembly {
    _matched += MatchedValue;
    _valueToken = [parser popToken];
}

-(void) parser:(PKParser * __nonnull) parser didMatchKeyPath:(PKAssembly * __nonnull) assembly {
    NSMutableArray *results = [@[] mutableCopy];
    while(!assembly.isStackEmpty) {
        [results insertObject:[parser popString] atIndex:0];
    }
    _keyPath = [results componentsJoinedByString:@"."];
}

-(void) parser:(PKParser * __nonnull) parser didMatchOp:(PKAssembly * __nonnull) assembly {
    _matched += MatchedOp;
    _opToken = [parser popToken];
}

#pragma mark - Tests

-(void) testString {
    [self parse:@"\"abc\""];
    XCTAssertEqual(_matched, MatchedValue);
    XCTAssertEqual(_valueToken.tokenKind, TOKEN_KIND_BUILTIN_QUOTEDSTRING);
    XCTAssertEqualObjects(@"abc", _valueToken.quotedStringValue);
}

-(void) testQuotedString {
    [self parse:@"abc"];
    XCTAssertEqual(_matched, MatchedValue);
    XCTAssertEqual(_valueToken.tokenKind, TOKEN_KIND_BUILTIN_WORD);
    XCTAssertEqualObjects(@"abc", _valueToken.value);
}

-(void) testNumber {
    [self parse:@"1.23"];
    XCTAssertEqual(_matched, MatchedValue);
    XCTAssertEqual(_valueToken.tokenKind, TOKEN_KIND_BUILTIN_NUMBER);
    XCTAssertEqualObjects(@(1.23), _valueToken.value);
}

-(void) testBooleanTrue {
    [self parse:@"true"];
    XCTAssertEqual(_matched, MatchedValue);
    XCTAssertEqual(_valueToken.tokenKind, STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE);
}

-(void) testBooleanYes {
    [self parse:@"YES"];
    XCTAssertEqual(_matched, MatchedValue);
    XCTAssertEqual(STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER, _valueToken.tokenKind);
}

-(void) testBooleanFalse {
    [self parse:@"false"];
    XCTAssertEqual(_matched, MatchedValue);
    XCTAssertEqual(STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE, _valueToken.tokenKind);
}

-(void) testBooleanNo {
    [self parse:@"NO"];
    XCTAssertEqual(_matched, MatchedValue);
    XCTAssertEqual(STLOGEXPRESSIONPARSER_TOKEN_KIND_NO_UPPER, _valueToken.tokenKind);
}

-(void) testClass {
    [self parse:@"[Abc]"];
    XCTAssertEqual(_matched, MatchedClass);
    XCTAssertEqual(_classToken.tokenKind, TOKEN_KIND_BUILTIN_WORD);
    XCTAssertEqualObjects(@"Abc", _classToken.value);
}

-(void) testProtocol {
    [self parse:@"<Abc>"];
    XCTAssertEqual(_matched, MatchedProtocol);
    XCTAssertEqual(_protocolToken.tokenKind, TOKEN_KIND_BUILTIN_WORD);
    XCTAssertEqualObjects(@"Abc", _protocolToken.value);
}

-(void) testClassPropertyEqualsString {

    [self parse:@"[Abc].userId = \"Derekc\""];

    XCTAssertEqual(MatchedClass + MatchedOp + MatchedValue, _matched);

    XCTAssertEqual(_classToken.tokenKind, TOKEN_KIND_BUILTIN_WORD);
    XCTAssertEqualObjects(@"Abc", _classToken.value);

    XCTAssertEqualObjects(@"userId", _keyPath);

    XCTAssertEqual(_opToken.tokenKind, STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ);

    XCTAssertEqual(_valueToken.tokenKind, TOKEN_KIND_BUILTIN_QUOTEDSTRING);
    XCTAssertEqualObjects(@"Derekc", _valueToken.quotedStringValue);

}

-(void) testClassKeyPathEqualsString {
    [self parse:@"[Abc].user.supervisor.name = \"Derekc\""];

    XCTAssertEqual(MatchedClass + MatchedOp + MatchedValue, _matched);

    XCTAssertEqual(_classToken.tokenKind, TOKEN_KIND_BUILTIN_WORD);
    XCTAssertEqualObjects(@"Abc", _classToken.value);

    XCTAssertEqualObjects(@"user.supervisor.name", _keyPath);

    XCTAssertEqual(_opToken.tokenKind, STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ);

    XCTAssertEqual(_valueToken.tokenKind, TOKEN_KIND_BUILTIN_QUOTEDSTRING);
    XCTAssertEqualObjects(@"Derekc", _valueToken.quotedStringValue);
}

-(void) testMissingValue {
    [self parse:@"[Abc].userId =" withCode:1 error:@"Failed to match next input token"];
}

-(void) testMissingClass {
    [self parse:@".userId = abc" withCode:1 error:@"Failed to match next input token"];
}

-(void) testMissingPath {
    [self parse:@"<Abc> = abc" withCode:1 error:@"Failed to match next input token"];
}

-(void) testMissingOp {
    [self parse:@"<Abc>.userId abc" withCode:1 error:@"Failed to match next input token"];
}

-(void) testInvalidOp {
    [self parse:@"<Abc>.userId >=< abc" withCode:1 error:@"Failed to match next input token"];
}

#pragma mark - Internal

-(void) parse:(NSString __nonnull *) string {
    NSError *localError = nil;
    STLogExpressionParser *parser = [[STLogExpressionParser alloc] initWithDelegate:self];
    PKAssembly __nonnull *result = [parser parseString:string error:&localError];
    XCTAssertNil(localError);
    XCTAssertNotNil(result.stack);
    NSArray __nonnull *results = result.stack;
    XCTAssertEqual(0u, [results count]);
}

-(void) parse:(NSString __nonnull *) string withCode:(NSInteger) code error:(NSString *) errorMessage {
    NSError *localError = nil;
    STLogExpressionParser *parser = [[STLogExpressionParser alloc] initWithDelegate:self];
    PKAssembly __nonnull *result = [parser parseString:string error:&localError];
    XCTAssertNotNil(localError);
    XCTAssertNil(result);
    XCTAssertEqualObjects(errorMessage, localError.localizedDescription);
    XCTAssertEqual(code, localError.code);
}

@end
