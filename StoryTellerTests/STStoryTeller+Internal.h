//
//  STStoryTeller+Internal.h
//  StoryTeller
//
//  Created by Derek Clarkson on 23/10/16.
//  Copyright © 2016 Derek Clarkson. All rights reserved.
//

// Accessing internal methods for testing purposes.
@interface STStoryTeller (Testing)
+(void) reset;
+(void) clearMatchers;
@end
