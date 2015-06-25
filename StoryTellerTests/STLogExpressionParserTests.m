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

@interface STLogExpressionParserTests : XCTestCase

@end

@implementation STLogExpressionParserTests

-(void) testString {
    [self parse:@"abc" withResults:@[@"abc"]];
}

-(void) testQuotedString {
    [self parse:@"\"abc\"" withResults:@[@"abc"]];
}

-(void) testNumber {
    [self parse:@"1.23" withResults:@[@(1.23)]];
}

-(void) testBoolean {
    [self parse:@"true" withResults:@[@YES]];
    [self parse:@"YES" withResults:@[@YES]];
    [self parse:@"false" withResults:@[@NO]];
    [self parse:@"NO" withResults:@[@NO]];
}

-(void) testClassOnly {
    [self parse:@"[STLogExpressionParserTests]" withResults:@[[STLogExpressionParserTests class]]];
}

-(void) testProtocolOnly {
    [self parse:@"<NSCopying>" withResults:@[@protocol(NSCopying)]];
}

-(void) testClassPropertyEqualsString {
    [self parse:@"[STLogExpressionParserTests].userId = \"Derekc\""
    withResults:@[
                  [STLogExpressionParserTests class],
                  @"userId",
                  @(STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ),
                  @"Derekc"
                  ]];
}

-(void) testClassKeyPathEqualsString {
    [self parse:@"[STLogExpressionParserTests].user.name = \"Derekc\""
    withResults:@[
                  [STLogExpressionParserTests class],
                  @"user.name",
                  @(STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ),
                  @"Derekc"
                  ]];
}

-(void) testUnknownClassReference {
    [self parse:@"[User].userId = \"Derekc\"" withError:@"Unknown class 'User'\nLine : 1\n"];
}

#pragma mark - Internal

-(void) parse:(NSString __nonnull *) string withResults:(NSArray __nonnull *) expectedResults {
    NSArray __nonnull *results = [self parse:string];
    XCTAssertEqual([expectedResults count], [results count]);
    [expectedResults enumerateObjectsUsingBlock:^(id  __nonnull expectedResult, NSUInteger idx, BOOL * __nonnull stop) {
        XCTAssertEqualObjects(expectedResult, results[idx]);
    }];
}

-(NSArray __nonnull *) parse:(NSString __nonnull *) string {
    NSError *localError = nil;
    STLogExpressionParser *parser = [[STLogExpressionParser alloc] init];
    PKAssembly __nonnull *result = [parser parseString:string error:&localError];
    XCTAssertNil(localError);
    XCTAssertNotNil(result.stack);
    return result.stack;
}

-(void) parse:(NSString __nonnull *) string withError:(NSString *) errorMessage {
    NSError *localError = nil;
    STLogExpressionParser *parser = [[STLogExpressionParser alloc] init];
    PKAssembly __nonnull *result = [parser parseString:string error:&localError];
    XCTAssertNotNil(localError);
    XCTAssertNil(result);
    XCTAssertEqualObjects(errorMessage, localError.localizedFailureReason);
}

@end
