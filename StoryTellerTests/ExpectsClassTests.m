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

@interface ExpectsClassTests : XCTestCase
@end

@implementation ExpectsClassTests {
    STExpressionMatcherFactory *_factory;
}

-(void) setUp {
    _factory = [[STExpressionMatcherFactory alloc] init];
}

-(void) testClassMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].classProperty is [SubClass]" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.classProperty = [SubClass class];
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testClassfailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].classProperty is [SubClass]" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.classProperty = [NSNumber class];
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testClassfailsMatchWhenAStringProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty is [SubClass]" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"abc";
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testClassfailsMatchWhenAProtocolProperty {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].protocolProperty is [SubClass]" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.protocolProperty = @protocol(NSCopying);
    XCTAssertFalse([matcher matches:mainClass]);
}

-(void) testMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty == [SubClass]" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    XCTAssertTrue([matcher matches:mainClass]);
}

@end
