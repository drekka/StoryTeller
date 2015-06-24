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

@implementation STLogExpressionParserTests {
    STLogExpressionParser *_parser;
}

-(void) setUp {
    _parser = [[STLogExpressionParser alloc] init];
}

-(void) testClassOnly {
    NSError *error = nil;
    PKAssembly __nonnull *result = [_parser parseString:@"[STLogExpressionParserTests]" error:&error];
    NSArray __nonnull *stack = result.stack;
    XCTAssertEqual(1u, [stack count]);
    XCTAssertEqual([STLogExpressionParserTests class], stack[0]);
}

-(void) testProtocolOnly {
    NSError *error = nil;
    PKAssembly __nonnull *result = [_parser parseString:@"<NSCopying>" error:&error];
    NSArray __nonnull *stack = result.stack;
    XCTAssertEqual(1u, [stack count]);
    XCTAssertEqual(@protocol(NSCopying), stack[0]);
}

-(void) testClassPropertyEqualsString {
    NSError *error = nil;
    PKAssembly __nonnull *result = [_parser parseString:@"[STLogExpressionParserTests].userId = \"Derekc\"" error:&error];
    XCTAssertNotNil(result);
    NSArray __nonnull *stack = result.stack;
    XCTAssertEqual([STLogExpressionParserTests class], stack[0]);
    XCTAssertEqualObjects(@"userId", stack[1]);
    XCTAssertEqual(STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ, ((PKToken *)stack[2]).tokenKind);
    XCTAssertEqualObjects(@"Derekc", stack[3]);
}

-(void) testClassKeyPathEqualsString {
    NSError *error = nil;
    PKAssembly __nonnull *result = [_parser parseString:@"[STLogExpressionParserTests].user.name = \"Derekc\"" error:&error];
    XCTAssertNotNil(result);
    NSArray __nonnull *stack = result.stack;
    XCTAssertEqual([STLogExpressionParserTests class], stack[0]);
    XCTAssertEqualObjects(@"user.name", stack[1]);
    XCTAssertEqual(STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ, ((PKToken *)stack[2]).tokenKind);
    XCTAssertEqualObjects(@"Derekc", stack[3]);
}

-(void) testUnknownClassReference {
    NSError *error = nil;
    PKAssembly __nonnull *result = [_parser parseString:@"[User].userId = \"Derekc\"" error:&error];
    XCTAssertNotNil(error);
    XCTAssertNil(result);
    XCTAssertEqualObjects(@"Unknown class 'User'\nLine : 1\n", error.localizedFailureReason);
}


@end
