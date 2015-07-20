#import <Foundation/Foundation.h>
@class Account2;

@interface User2 : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<Account2 *> *accounts;

-(void) processAccounts;

@end
