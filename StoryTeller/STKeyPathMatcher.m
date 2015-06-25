//
//  STKeyPathMatcher.m
//  StoryTeller
//
//  Created by Derek Clarkson on 26/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STKeyPathMatcher.h"

@implementation STKeyPathMatcher

-(nonnull instancetype) initWithKeyPath:(NSString __nonnull *) keyPath {
    self = [super init];
    if (self) {
        _keyPath = keyPath;
    }
    return self;
}

-(BOOL) matches:(id __nonnull) key {

    id value = key valueForKeyPath:<#(nonnull NSString *)#>


    //&& (self.nextMatcher == nil ? YES : [self.nextMatcher matches:key]);
}

@end
