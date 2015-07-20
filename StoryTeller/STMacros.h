//
//  STMacros.h
//  StoryTeller
//
//  Created by Derek Clarkson on 24/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import <StoryTeller/STSToryTeller.h>
#import <StoryTeller/STDeallocHook.h>

#ifdef DISABLE_STORY_TELLER

// Remove all logging code.
#define STStartLogging(key)
#define STStartScope(key)
#define STEndScope(key)
#define STLog(key, messageTemplate, ...)
#define STExecuteBlock(key, codeBlock)

#else

// Internal macro - don't use publically.
#define _ST_CONCAT(prefix, suffix) prefix ## suffix

// Concantiates the two values using another macro to do the work. This allows a level of indirection which
// means that macros such as __LINE__ can be concatinated.
#define ST_CONCATINATE(prefix, suffix) _ST_CONCAT(prefix, suffix)

#define STStartLogging(key) \
[[STStoryTeller storyTeller] startLogging:key]

#define STStartScope(key) \
_Pragma ("clang diagnostic push") \
_Pragma ("clang diagnostic ignored \"-Wunused-variable\"") \
NS_VALID_UNTIL_END_OF_SCOPE STDeallocHook *ST_CONCATINATE(_stHook_, __LINE__) = [[STDeallocHook alloc] initWithBlock:^{ \
STEndScope(key); \
}]; \
_Pragma ("clang diagnostic pop") \
[[STStoryTeller storyTeller] startScope:key]

#define STEndScope(key) \
[[STStoryTeller storyTeller] endScope:key]

#define STLog(key, messageTemplate, ...) \
[[STStoryTeller storyTeller] record:key file:__FILE__ method: __func__ lineNumber: __LINE__ message:messageTemplate, ## __VA_ARGS__]

#define STExecuteBlock(key, codeBlock) \
[[STStoryTeller storyTeller] execute:key block:codeBlock]

#endif
