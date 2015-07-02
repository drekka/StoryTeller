//
//  MainClass.h
//  StoryTeller
//
//  Created by Derek Clarkson on 2/07/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import "SubClass.h"
#import "AProtocol.h"

@interface MainClass : NSObject<AProtocol>
@property (nonatomic, strong) NSString *stringProperty;
@property (nonatomic, strong) SubClass *subClassProperty;
@property (nonatomic, assign) Class classProperty;
@property (nonatomic, strong) Protocol *protocolProperty;
@end
