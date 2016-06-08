//
//  STLogExpressionParserDelegateTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
@import StoryTeller.Private;
#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"

@interface ExpectsNumberTests : XCTestCase
@end

@implementation ExpectsNumberTests {
    STLogExpressionParserDelegate *_factory;
}

-(void) setUp {
    _factory = [[STLogExpressionParserDelegate alloc] init];
}

#pragma mark - Type checks

-(void) testWhenStringProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"abc";
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testWhenClassProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].classProperty == 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.classProperty = [NSString class];
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testWhenProtocolProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].protocolProperty == 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.protocolProperty = @protocol(NSCopying);
    XCTAssertFalse([matcher matches:mainClass]);
}

#pragma mark - Number checks

-(void) testEQWhenEqual {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty == 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testEQWhenNotEqual {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty == 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 1;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testNEWhenEqual {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty != 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testNEWhenNotEqual {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty != 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 1;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testGTWhenGreaterThan {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty > 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 6;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testGTWhenEqual {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty > 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testGEWhenEqual {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty >= 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testGEWhenGreaterThan {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty >= 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 6;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testGEWhenLessThan {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty >= 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 4;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testLTWhenLessThan {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty < 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 4;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testLTWhenEqual {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty < 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testLEWhenEqual {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty <= 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testLEWhenGreaterThan {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty <= 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 6;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testLEWhenLessThan {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty <= 5"];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 4;
    XCTAssertTrue([matcher matches:mainClass]);
}

@end
