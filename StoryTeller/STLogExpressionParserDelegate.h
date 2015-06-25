//
//  STLogExpressionParserDelegate.h
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import Foundation;
#import <PEGKit/PEGKit.h>

@protocol STLogExpressionParserDelegate <NSObject>

-(void) parser:(PKParser __nonnull *) parser didMatchClass:(PKAssembly __nonnull *) assembly;
-(void) parser:(PKParser __nonnull *) parser didMatchProtocol:(PKAssembly __nonnull *) assembly;
-(void) parser:(PKParser __nonnull *) parser didMatchValue:(PKAssembly __nonnull *) assembly;
-(void) parser:(PKParser __nonnull *) parser didMatchKeyPath:(PKAssembly __nonnull *) assembly;
-(void) parser:(PKParser __nonnull *) parser didMatchOp:(PKAssembly __nonnull *) assembly;

@end
