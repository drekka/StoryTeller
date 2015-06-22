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

-(void) testReadingStringsAsBooleans {
    [self setValue:@"YES" forKeyPath:@"booleanProperty"];
    XCTAssertTrue(self.booleanProperty);
    [self setValue:@"NO" forKeyPath:@"booleanProperty"];
    XCTAssertFalse(self.booleanProperty);
}

@end
