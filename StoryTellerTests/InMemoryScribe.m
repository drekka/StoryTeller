//
//  InMemoryScribe.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "InMemoryScribe.h"

@implementation InMemoryScribe {
    NSMutableArray<NSString *> *_log;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _log = [@[] mutableCopy];
    }
    return self;
}

-(void)writeMessage:(NSString *)message fromMethod:(const char *)methodName lineNumber:(int)lineNumber {
    [_log addObject:message];
}

-(NSArray *) log {
    return _log;
}

@end
