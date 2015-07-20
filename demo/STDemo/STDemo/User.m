#import "User.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "Header.h"
#import "Account.h"

@implementation User

-(void) processAccounts {

    DDLogDebug(@"processing accounts for %@", self.name);
    for (Account *account in self.accounts) {
        DDLogDebug(@"Processing account %@", account);
        [account processTransactions];
    }

}

@end
