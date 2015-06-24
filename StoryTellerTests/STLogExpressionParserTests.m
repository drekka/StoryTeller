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

-(void) testClassPropertyEqualsString {
    NSError *error = nil;
    PKAssembly __nonnull *result = [_parser parseString:@"[User].userId = \"Derekc\"" error:&error];
    XCTAssertNotNil(result);
    NSArray<PKToken *> __nonnull *stack = result.stack;
    XCTAssertEqualObjects(@"User", stack[0].value);
    XCTAssertEqualObjects(@".userId", stack[1].value);
    XCTAssertEqualObjects(@"=", stack[2].value);
    XCTAssertEqualObjects(@"Derekc", stack[3].value);
}


@end
