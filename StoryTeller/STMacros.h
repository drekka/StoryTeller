//
//  STMacros.h
//  StoryTeller
//
//  Created by Derek Clarkson on 24/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "STSToryTeller.h"

// Internal macro - don't use publically.
#define _ST_CONCAT(prefix, suffix) prefix ## suffix

// Concantiates the two values using another macro to do the work. This allows a level of indirection which
// means that macros such as __LINE__ can be concatinated.
#define ST_CONCATINATE(prefix, suffix) _ST_CONCAT(prefix, suffix)

// Note the NS_VALID_UNTIL_END_OF_SCOPE macro. This ensures that the variable does not immediately dealloc.
#define STStartScope(key) \
NS_VALID_UNTIL_END_OF_SCOPE __unused id ST_CONCATINATE(_stHook_, __LINE__) = [[STStoryTeller instance] startScope:key]

#define STLog(key, messageTemplate, ...) \
[[STStoryTeller instance] record:key file:__FILE__ method: __func__ lineNumber: __LINE__ message:messageTemplate, ## __VA_ARGS__]

#define STExecuteBlock(key, codeBlock) \
[[STStoryTeller instance] execute:key block:codeBlock]

