#import "User2.h"
#import "Header.h"
#import "Account2.h"
#import <StoryTeller/StoryTeller.h>

@implementation User2

-(void) processAccounts {

    STLog(self, @"processing accounts for %@", self.name);
    //STStartScope(self);
    for (Account2 *account in self.accounts) {
        STLog(self, @"processing account %@", account);
        [account processTransactions];
    }

}

@end
