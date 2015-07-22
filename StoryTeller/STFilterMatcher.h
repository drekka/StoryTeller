//
//  STFilterMatcher.h
//  StoryTeller
//
//  Created by Derek Clarkson on 26/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STMatcher.h"

@interface STFilterMatcher : NSObject<STMatcher>

@property (nonatomic, strong, nonnull) id<STMatcher> nextMatcher;

-(nonnull instancetype) initWithFilter:(_Nullable id (^ _Nonnull)(_Nonnull id key)) filterBlock;

@end
