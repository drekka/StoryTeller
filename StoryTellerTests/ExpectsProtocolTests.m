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

@interface ExpectsProtocolTests : XCTestCase
@end

@implementation ExpectsProtocolTests {
    STExpressionMatcherFactory *_factory;
}

-(void) setUp {
    _factory = [[STExpressionMatcherFactory alloc] init];
}

-(void) testPropertyProtocolMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].protocolProperty is <AProtocol>" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.protocolProperty = @protocol(AProtocol);
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyObjectProtocolMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty == <AProtocol>" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertTrue([matcher matches:mainClass]);
}

@end
