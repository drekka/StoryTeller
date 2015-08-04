//
//  STChronicleHook.h
//  StoryTeller
//
//  Created by Derek Clarkson on 19/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 Simple class that is designed to execute a block when a variable goes out of scope.
 
 @discussion To use it, do something like the following

    id hook = [[STDeallocHook alloc] initWithBlock:^{
	    // Do something when 'hook' is dealloced
    }];

 When `hook` goes out of scope and is deallocated, the code block will be executed. In Story Teller, STDeallocHook is used to detect when a `startScope(...)` macro should end the scope of the key. The hook simply calls endScope:.
 */
@interface STDeallocHook : NSObject

/**
 Default initialiser.
 
 @param simpleBlock the block to execute when the variable goes out of scope.
 */
-(instancetype) initWithBlock:(void (^)(void)) simpleBlock;

@end

NS_ASSUME_NONNULL_END