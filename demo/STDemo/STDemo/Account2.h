#import <Foundation/Foundation.h>

@interface Account2 : NSObject

@property(nonatomic, strong) NSDecimalNumber *balance;
@property(nonatomic, strong) NSString *accountNumber;

-(void) processTransactions;

@end
