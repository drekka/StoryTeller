//
//  STChronicleHook.h
//  StoryTeller
//
//  Created by Derek Clarkson on 19/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;

@interface STDeallocHook : NSObject

-(nonnull instancetype) initWithBlock:(__nonnull void (^)(void)) simpleBlock;

@end
