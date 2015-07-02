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

@interface ExpectsNumberTests : XCTestCase
@end

@implementation ExpectsNumberTests {
    STExpressionMatcherFactory *_factory;
}

-(void) setUp {
    _factory = [[STExpressionMatcherFactory alloc] init];
}

-(void) testEqualsMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty == 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testNotEqualsMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty != 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 1;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testGTMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty > 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 6;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testGTFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty > 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testGEWhenEqualMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty >= 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testGEMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty >= 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 6;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testGEFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty >= 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 4;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testLTMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty < 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 4;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testLTFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intProperty < 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testLEWhenEqualMatches {
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
