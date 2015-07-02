//
//  STExpressionMatcherFactoryTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
#import "STExpressionMatcherFactory.h"
#import "STMatcher.h"
#import "MainClass.h"
#import "SubClass.h"
#import "AProtocol.h"

@interface STExpressionMatcherFactoryTests : XCTestCase
@end

@implementation STExpressionMatcherFactoryTests {
    STExpressionMatcherFactory *_factory;
}

-(void) setUp {
    _factory = [[STExpressionMatcherFactory alloc] init];
}

-(void) testPropertyIntEqualsMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty == 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyIntNotEqualsMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty != 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 1;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyIntGTMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty > 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 6;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyIntGTFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty > 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testPropertyIntGEWhenEqualMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty >= 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyIntGEMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty >= 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 6;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyIntGEFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty >= 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 4;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testPropertyIntLTMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty < 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 4;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyIntLTFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty < 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testPropertyIntLEWhenEqualMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty <= 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyIntLEWhenEqualFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty <= 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 6;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testPropertyIntLEMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty <= 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 4;
    XCTAssertTrue([matcher matches:mainClass]);
}

@end
