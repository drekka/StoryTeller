#import <Foundation/Foundation.h>
@class Account;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<Account *> *accounts;

-(void) processAccounts;

@end
