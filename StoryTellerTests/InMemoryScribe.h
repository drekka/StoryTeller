//
//  InMemoryScribe.h
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STScribe.h"

@interface InMemoryScribe : NSObject<STScribe>

@property (nonatomic, strong, readonly, nonnull) NSArray *log;

@end