
@import XCTest;
#import "User.h"
#import "Account.h"
#import "User2.h"
#import "Account2.h"

#import <CocoaLumberjack/CocoaLumberjack.h>
#import <StoryTeller/StoryTeller.h>

@interface STDemoTests : XCTestCase

@end

@implementation STDemoTests {
    NSArray *_users;
    NSArray *_users2;
}

-(void) setUp {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    [self setUPUsers];
    [self setUPUsers2];

    ((STConsoleLogger *)[STStoryTeller storyTeller].logger).addXcodeColours = YES;
    ((STConsoleLogger *)[STStoryTeller storyTeller].logger).messageColour = [UIColor yellowColor];
}


-(void) testAccountsDD {
    for (User *user in _users) {
        [user processAccounts];
    }
}

-(void) testAccountsST {
    STStartLogging(@"[User2].name == Derek");
    for (User2 *user in _users2) {
        [user processAccounts];
    }
}

-(void) setUPUsers {
    User *derek = [[User alloc] init];
    derek.name = @"Derek";
    Account *account1 = [[Account alloc] init];
    account1.balance = [NSDecimalNumber decimalNumberWithString:@"10.00"];
    account1.accountNumber = @"1234";
    Account *account2 = [[Account alloc] init];
    account2.balance = [NSDecimalNumber decimalNumberWithString:@"600.00"];
    account2.accountNumber = @"5674";
    derek.accounts = @[account1, account2];

    User *fred = [[User alloc] init];
    fred.name = @"Fred";
    account1 = [[Account alloc] init];
    account1.balance = [NSDecimalNumber decimalNumberWithString:@"450.00"];
    account1.accountNumber = @"33333";
    account2 = [[Account alloc] init];
    account2.balance = [NSDecimalNumber decimalNumberWithString:@"30.00"];
    account2.accountNumber = @"33345343";
    fred.accounts = @[account1, account2];

    User *bob = [[User alloc] init];
    bob.name = @"Bob";
    account1 = [[Account alloc] init];
    account1.balance = [NSDecimalNumber decimalNumberWithString:@"120.00"];
    account1.accountNumber = @"7272628";
    account2 = [[Account alloc] init];
    account2.balance = [NSDecimalNumber decimalNumberWithString:@"10000.00"];
    account2.accountNumber = @"12434o23423";
    bob.accounts = @[account1, account2];

    _users = @[derek, fred, bob];

}

-(void) setUPUsers2 {
    User2 *derek = [[User2 alloc] init];
    derek.name = @"Derek";
    Account2 *account1 = [[Account2 alloc] init];
    account1.balance = [NSDecimalNumber decimalNumberWithString:@"10.00"];
    account1.accountNumber = @"1234";
    Account2 *account2 = [[Account2 alloc] init];
    account2.balance = [NSDecimalNumber decimalNumberWithString:@"600.00"];
    account2.accountNumber = @"5674";
    derek.accounts = @[account1, account2];

    User2 *fred = [[User2 alloc] init];
    fred.name = @"Fred";
    account1 = [[Account2 alloc] init];
    account1.balance = [NSDecimalNumber decimalNumberWithString:@"450.00"];
    account1.accountNumber = @"33333";
    account2 = [[Account2 alloc] init];
    account2.balance = [NSDecimalNumber decimalNumberWithString:@"30.00"];
    account2.accountNumber = @"33345343";
    fred.accounts = @[account1, account2];

    User2 *bob = [[User2 alloc] init];
    bob.name = @"Bob";
    account1 = [[Account2 alloc] init];
    account1.balance = [NSDecimalNumber decimalNumberWithString:@"120.00"];
    account1.accountNumber = @"7272628";
    account2 = [[Account2 alloc] init];
    account2.balance = [NSDecimalNumber decimalNumberWithString:@"10000.00"];
    account2.accountNumber = @"12434o23423";
    bob.accounts = @[account1, account2];

    _users2 = @[derek, fred, bob];
    
}

@end
