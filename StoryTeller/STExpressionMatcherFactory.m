//
//  STExpressionMatcherFactory.m
//  StoryTeller
//
//  Created by Derek Clarkson on 25/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STExpressionMatcherFactory.h"
#import <PEGKit/PEGKit.h>
#import "STLogExpressionParser.h"

@implementation STExpressionMatcherFactory {
    STLogExpressionParser *_parser;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _parser = [[STLogExpressionParser alloc] initWithDelegate:self];
    }
    return self;
}

-(id) parseExpression:(NSString *)expression {
    return nil;
}

#pragma mark - Delegate methods

-(void) parser:(PKParser __nonnull *) parser didMatchProtocol:(PKAssembly __nonnull *) assembly {
    PKToken *token = [assembly pop];
    NSLog(@"%@", token);

}

-(void) parser:(PKParser __nonnull *) parser didMatchClass:(PKAssembly __nonnull *) assembly {

}

-(void) parser:(PKParser __nonnull *) parser didMatchValue:(PKAssembly __nonnull *) assembly {

}

-(void) parser:(PKParser __nonnull *) parser didMatchKeyPath:(PKAssembly __nonnull *) assembly {

}
-(void) parser:(PKParser __nonnull *) parser didMatchOp:(PKAssembly __nonnull *) assembly {

}


@end
