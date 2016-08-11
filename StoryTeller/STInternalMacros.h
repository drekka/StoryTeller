//
//  STInternalMacros.h
//  StoryTeller
//
//  Created by Derek Clarkson on 10/8/16.
//  Copyright © 2016 Derek Clarkson. All rights reserved.
//

#ifdef ST_DEBUG
#define STDebugLog(template, ...) NSLog(template, ## __VA_ARGS__ )
#else
#define STDebugLog(template, ...)
#endif

