//
//  STClassMatcher.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STClassMatcher.h"

@implementation STClassMatcher {
    Class _targetClass;
}

@synthesize nextMatcher = _nextMatcher;

-(instancetype) initWithClass:(Class) targetClass {
    self = [super init];
    if (self) {
        _targetClass = targetClass;
    }
    return self;
}

-(BOOL) matches:(id)key {
    return [key isKindOfClass:_targetClass]
    && (self.nextMatcher == nil ? YES : [self.nextMatcher matches:key]);
}

@end
