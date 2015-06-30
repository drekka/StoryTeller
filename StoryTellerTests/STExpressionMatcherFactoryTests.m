//
//  STExpressionMatcherFactoryTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import XCTest;
#import <OCMock/OCMock.h>
#import <StoryTeller/StoryTeller.h>
#import "STExpressionMatcherFactory.h"
#import "STMatcher.h"

@interface SubClass : NSObject
@property (nonatomic, assign) BOOL boolProperty;
@end

@implementation SubClass
@end

@protocol AProtocol <NSObject>
@property (nonatomic, assign) int intProperty;
@end

@interface MainClass : NSObject<AProtocol>
@property (nonatomic, strong) NSString *stringProperty;
@property (nonatomic, strong) SubClass *subClassProperty;
@property (nonatomic, assign) Class classProperty;
@property (nonatomic, strong) Protocol *protocolProperty;
@end

@implementation MainClass
@synthesize intProperty = _intProperty;
@end

@interface STExpressionMatcherFactoryTests : XCTestCase
@end

@implementation STExpressionMatcherFactoryTests {
    STExpressionMatcherFactory *_factory;
    id _mockStoryTeller;
}

-(void) setUp {
    _factory = [[STExpressionMatcherFactory alloc] init];

    // Mock out story teller.
    _mockStoryTeller = OCMClassMock([STStoryTeller class]);
    OCMStub([_mockStoryTeller storyTeller]).andReturn(_mockStoryTeller);
}

-(void) tearDown {
    [_mockStoryTeller stopMocking];
}

#pragma mark - Options

-(void) testLogAll {
    id<STMatcher> matcher = [_factory parseExpression:@"LogAll" error:NULL];
    XCTAssertNil(matcher);
    OCMVerify([_mockStoryTeller logAll]);
}

-(void) testLogRoots {
    id<STMatcher> matcher = [_factory parseExpression:@"LogRoots" error:NULL];
    XCTAssertNil(matcher);
    OCMVerify([_mockStoryTeller logRoots]);
}

#pragma mark - Simple values

-(void) testStringMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"abc" error:NULL];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testStringFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"abc" error:NULL];
    XCTAssertFalse([matcher matches:@"def"]);
}

-(void) testNumberMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"12" error:NULL];
    XCTAssertTrue([matcher matches:@12]);
}

-(void) testNumberFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"12.5" error:NULL];
    XCTAssertFalse([matcher matches:@12.678]);
}

#pragma mark - Classes

-(void) testClassMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]" error:NULL];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testClassIsUnknown {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[Abc]" error:&error];
    XCTAssertNil(matcher);
    XCTAssertEqualObjects(@"Unable to find class Abc", error.localizedDescription);
}

-(void) testClassFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[NSString]" error:NULL];
    XCTAssertFalse([matcher matches:@12]);
}

#pragma mark - Protocols

-(void) testProtocolMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"<NSCopying>" error:NULL];
    XCTAssertTrue([matcher matches:@"abc"]);
}

-(void) testProtocolUnknown {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"<Abc>" error:&error];
    XCTAssertNil(matcher);
    XCTAssertEqualObjects(@"Unable to find protocol Abc\nLine : Unknown\n", error.localizedFailureReason);
}

-(void) testProtocolFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"<NSFastEnumeration>" error:NULL];
    XCTAssertFalse([matcher matches:@12]);
}

-(void) testProtocolIntPropertyMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"<AProtocol>.intProperty == 5" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.intProperty = 5;
    XCTAssertTrue([matcher matches:mainClass]);
}

#pragma mark - General Properties

-(void) testPropertyUnknown {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].intPropertyxxx == abc" error:&error];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertThrowsSpecificNamed([matcher matches:mainClass], NSException, @"NSUnknownKeyException");
}

#pragma mark - String Properties

-(void) testPropertyQuotedStringMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == \"abc\"" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"abc";
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyUnQuotedStringMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == abc" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"abc";
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyUnQuotedStringFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == abc" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertFalse([matcher matches:mainClass]);
}

#pragma mark - Nil Properties

-(void) testPropertyNilMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == nil" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyNilNotEqualMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty != nil" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyNilFailsMatch {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].stringProperty == nil" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.stringProperty = @"def";
    XCTAssertFalse([matcher matches:mainClass]);
}

#pragma mark - Number Properties

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

#pragma mark - Bool Properties

-(void) testPropertyNestedBoolTrueMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == true" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyNestedBoolNotFalseMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty != false" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    SubClass *subClass = [[SubClass alloc] init];
    mainClass.subClassProperty = subClass;
    subClass.boolProperty = YES;
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyNestedBoolYesMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty == YES" error:NULL];
    MainClass *a = [[MainClass alloc] init];
    SubClass *b = [[SubClass alloc] init];
    a.subClassProperty = b;
    b.boolProperty = YES;
    XCTAssertTrue([matcher matches:a]);
}

-(void) testPropertyNestedBoolInvalidOp {
    NSError *error = nil;
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].subClassProperty.boolProperty > YES" error:&error];
    XCTAssertNil(matcher);
    XCTAssertEqualObjects(@"Failed to match next input token", error.localizedDescription);
}

#pragma mark - Runtime Properties

-(void) testPropertyClassMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].classProperty is [SubClass]" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.classProperty = [SubClass class];
    XCTAssertTrue([matcher matches:mainClass]);
}

-(void) testPropertyProtocolMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"[MainClass].protocolProperty is <AProtocol>" error:NULL];
    MainClass *mainClass = [[MainClass alloc] init];
    mainClass.protocolProperty = @protocol(AProtocol);
    XCTAssertTrue([matcher matches:mainClass]);
}

#pragma mark - Runtime

-(void) testIsaClassMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"is [MainClass]" error:NULL];
    XCTAssertTrue([matcher matches:[MainClass class]]);
}

-(void) testIsaProtocolMatches {
    id<STMatcher> matcher = [_factory parseExpression:@"is <AProtocol>" error:NULL];
    XCTAssertTrue([matcher matches:@protocol(AProtocol)]);
}

@end
