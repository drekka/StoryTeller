//
//  STTestCase.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
@import XCTest;
#import "InMemoryScribe.h"

@interface STTestCase : XCTestCase

@property (nonatomic, strong, nonnull, readonly) InMemoryScribe *inMemoryScribe;

@end