//
//  StoryTeller
//
//  Created by Derek Clarkson on 18/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "InMemoryLogger.h"

@implementation InMemoryLogger

-(instancetype) init {
    self = [super init];
    if (self) {
        _log = [@[] mutableCopy];
    }
    return self;
}

-(void)writeText:(char *) text {
    [(NSMutableArray *)_log addObject:[NSString stringWithUTF8String:text]];
}

@end
