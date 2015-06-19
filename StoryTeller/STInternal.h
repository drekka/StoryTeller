//
//  STInternal.h
//  StoryTeller
//
//  Created by Derek Clarkson on 19/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

// Internal macro - don't use publically.
#define _ST_CONCAT(prefix, suffix) prefix ## suffix

// Concantiates the two values using another macro to do the work. This allows a level of indirection which
// means that macros such as __LINE__ can be concatinated.
#define ST_CONCATINATE(prefix, suffix) _ST_CONCAT(prefix, suffix)

