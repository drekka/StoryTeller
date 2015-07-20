#import <Foundation/Foundation.h>

@interface Account : NSObject

@property(nonatomic, strong) NSDecimalNumber *balance;
@property(nonatomic, strong) NSString *accountNumber;

-(void) processTransactions;

@end
