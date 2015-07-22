//
//  STChronicleHook.m
//  StoryTeller
//
//  Created by Derek Clarkson on 19/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STDeallocHook.h"

NS_ASSUME_NONNULL_BEGIN

@implementation STDeallocHook {
	void (^_deallocBlock)(void);
}

-(instancetype) initWithBlock:(void (^)(void)) simpleBlock {
    self = [super init];
    if (self) {
        _deallocBlock = simpleBlock;
    }
    return self;
}

-(void) dealloc {
    _deallocBlock();
}

@end

NS_ASSUME_NONNULL_END
