//
//  InMemoryScribe.m
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "InMemoryLogger.h"

@implementation InMemoryLogger {
    NSMutableArray<NSString *> *_log;
    NSMutableString *_cache;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _log = [@[] mutableCopy];
    }
    return self;
}

-(void)writeText:(const char * __nonnull)text {

    if (_cache == nil) {
        _cache = [[NSMutableString alloc] init];
    }

    NSString *fragment = [NSString stringWithUTF8String:text];
    if ([@"\n" isEqualToString:fragment]) {
        // end of line.
        printf("%s\n", [_cache UTF8String]);
        [_log addObject:_cache];
        _cache = nil;
    } else {
        [_cache appendString:fragment];
    }

}

-(NSArray *) log {
    return _log;
}

@end
