#import "Account.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "Header.h"

@implementation Account

-(void) processTransactions {
    DDLogDebug(@"Doing magic with balance: %@", self.balance);
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Account %@", self.accountNumber];
}

@end
