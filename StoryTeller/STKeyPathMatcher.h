//
//  STKeyPathMatcher.h
//  StoryTeller
//
//  Created by Derek Clarkson on 26/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STMatcher.h"

@interface STKeyPathMatcher : NSObject<STMatcher>

@property (nonatomic, strong, nonnull, readonly) NSString *keyPath;

-(nonnull instancetype) initWithKeyPath:(NSString __nonnull *) keyPath;

@end
