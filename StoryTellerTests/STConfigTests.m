//
//  STConfigTests.m
//  StoryTeller
//
//  Created by Derek Clarkson on 22/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <StoryTeller/StoryTeller.h>

@interface STConfigTests : XCTestCase
@property (nonatomic, assign) BOOL booleanProperty;
@end

@implementation STConfigTests

-(void) testConfig {

    STConfig *config = [[STConfig alloc] init];
    NSProcessInfo *currentProcessInfo = [NSProcessInfo processInfo];
    currentProcessInfo searguments = @[];


}

-(void) testReadingYESNOStringsAsBooleans {
    [self setValue:@"YES" forKeyPath:@"booleanProperty"];
    XCTAssertTrue(self.booleanProperty);
    [self setValue:@"NO" forKeyPath:@"booleanProperty"];
    XCTAssertFalse(self.booleanProperty);
}

-(void) testReadingTrueFalseStringsAsBooleans {
    [self setValue:@"true" forKeyPath:@"booleanProperty"];
    XCTAssertTrue(self.booleanProperty);
    [self setValue:@"false" forKeyPath:@"booleanProperty"];
    XCTAssertFalse(self.booleanProperty);
}

-(void) testReading10StringsAsBooleans {
    [self setValue:@"1" forKeyPath:@"booleanProperty"];
    XCTAssertTrue(self.booleanProperty);
    [self setValue:@"0" forKeyPath:@"booleanProperty"];
    XCTAssertFalse(self.booleanProperty);
}

@end
