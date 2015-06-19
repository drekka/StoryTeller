//
//  StoryTellerTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STTestCase.h"
#import "StoryTeller.h"

@interface StoryTellerTests : STTestCase

@end

@implementation StoryTellerTests {
    int _helloAgainLogLine;
    const char * _helloAgainMethodName;
}

-(void) testIsChronicleActive {
    startChronicle(@"abc");
    XCTAssertTrue([storyteller isChronicleActiveFor:@"abc"]);
    XCTAssertFalse([storyteller isChronicleActiveFor:@"def"]);
}

-(void) testBasicLogging {
    int logLine = __LINE__ + 1;
    narrate(@"abc", @"hello world");
    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine message:@"hello world"];
}

-(void) testLoggingIgnoredWhenHeroNotStarted {
    narrate(@"abc", @"hello world");
    XCTAssertEqual(0lu, [self.inMemoryScribe.log count]);
}

-(void) testMultipleChronicles {

    startChronicle(@"abc");
    int abcLogLine = __LINE__ + 1;
    narrate(@"abc", @"hello world");

    startChronicle(@"def");
    int defLogLine = __LINE__ + 1;
    narrate(@"def", @"hello world 2");

    XCTAssertEqual(02u, [self.inMemoryScribe.log count]);
    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:abcLogLine message:@"hello world"];
    [self validateLogLineAtIndex:1 methodName:__PRETTY_FUNCTION__ lineNumber:defLogLine message:@"hello world 2"];
}

-(void) testChroniclesInLoop {

    NSArray<NSString *> *heros = @[@"abc", @"def"];
    NSMutableArray<NSNumber *> *logLineNumbers = [@[] mutableCopy];

    __block const char *blockMethodName;
    [heros enumerateObjectsUsingBlock:^(NSString * __nonnull hero, NSUInteger idx, BOOL * __nonnull stop) {
        blockMethodName = __PRETTY_FUNCTION__;
        startChronicle(hero);
        logLineNumbers[idx] = @(__LINE__ + 1);
        narrate(hero, [NSString stringWithFormat:@"hello world %@", hero]);
        XCTAssertEqual(1, storyteller.numberActiveChronicles);
    }];

    XCTAssertEqual(02u, [self.inMemoryScribe.log count]);
    [self validateLogLineAtIndex:0 methodName:blockMethodName lineNumber:logLineNumbers[0].intValue message:@"hello world abc"];
    [self validateLogLineAtIndex:1 methodName:blockMethodName lineNumber:logLineNumbers[1].intValue message:@"hello world def"];
}

-(void) testLogAppearsFromNestedLogWhenDifferentHero {

    startChronicle(@"abc");
    int logLine = __LINE__ + 1;
    narrate(@"abc", @"hello world");
    [self sayHelloAgain];

    XCTAssertEqual(2lu, [self.inMemoryScribe.log count]);

    [self validateLogLineAtIndex:0 methodName:__PRETTY_FUNCTION__ lineNumber:logLine message:@"hello world"];
    [self validateLogLineAtIndex:1 methodName:_helloAgainMethodName lineNumber:_helloAgainLogLine message:@"hello world 2"];
}

-(void) testNarrateBlock {
    startChronicle(@"abc");
    __block BOOL blockCalled = NO;
    narrateBlock(@"abc", ^(id hero) {
        blockCalled = YES;
    });
    XCTAssertTrue(blockCalled);
}

-(void) validateLogLineAtIndex:(unsigned long) idx
                    methodName:(const char __nonnull *) methodName
                    lineNumber:(int) lineNumber
                       message:(NSString __nonnull *) message {
    NSString *expected = [NSString stringWithFormat:@"<a07> %s(%i) %@", methodName, lineNumber, message];
    XCTAssertEqualObjects(expected, [self.inMemoryScribe.log[idx] substringFromIndex:13]);
}

-(void) sayHelloAgain {
    _helloAgainMethodName = __PRETTY_FUNCTION__;
    _helloAgainLogLine = __LINE__ + 1;
    narrate(@"def", @"hello world 2");
}

@end
