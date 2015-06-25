//
//  STProtocolMatcher.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STProtocolMatcher.h"

@implementation STProtocolMatcher {
    Protocol *_protocol;
}

@synthesize nextMatcher = _nextMatcher;

-(nonnull instancetype) initWithProtocol:(Protocol __nonnull *) protocol {
    self = [super init];
    if (self) {
        _protocol = protocol;
    }
    return self;
}

-(BOOL) matches:(id __nonnull) key {
    return [key conformsToProtocol:_protocol]
    && (self.nextMatcher == nil ? YES : [self.nextMatcher matches:key]);
}

@end
