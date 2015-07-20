#import "Account2.h"
#import "Header.h"
#import <StoryTeller/StoryTeller.h>

@implementation Account2

-(void) processTransactions {
    STLog(self, @"Doing magic with balance: %@", self.balance);
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Account %@", self.accountNumber];
}

@end
