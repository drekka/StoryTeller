//
//  STProtocolMatcher.h
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STMatcher.h"

@interface STProtocolMatcher : NSObject<STMatcher>

@property (nonatomic, strong, nonnull, readonly) Protocol *protocol;

-(nonnull instancetype) initWithProtocol:(Protocol __nonnull *) protocol;

@end
