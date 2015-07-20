//
//  SubClass.h
//  StoryTeller
//
//  Created by Derek Clarkson on 2/07/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "AProtocol.h"
@import Foundation;

@interface SubClass : NSObject<AProtocol>
@property (nonatomic, assign) BOOL boolProperty;
@end
