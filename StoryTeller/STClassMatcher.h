//
//  STClassMatcher.h
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STMatcher.h"

@interface STClassMatcher : NSObject<STMatcher>

@property (nonatomic, assign, nonnull, readonly) Class forClass;

-(nonnull instancetype) initWithClass:(Class __nonnull) forClass;

@end
