//
//  STConfig.m
//  StoryTeller
//
//  Created by Derek Clarkson on 22/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import ObjectiveC;

#import <PEGKit/PEGKit.h>

#import "STConfig.h"
#import "STStoryTeller.h"
#import "STConsoleLogger.h"

NS_ASSUME_NONNULL_BEGIN

// Properties loaded from config sources via KVC
@interface STConfig ()
@property (nonatomic, strong) NSArray<NSString *> *activeLogs;
@property (nonatomic, strong) NSString *loggerClass;
@property (nonatomic, strong) NSString *logLineTemplate;
@end

@implementation STConfig {
    // This is mainly used to stop EXC_BAD_ACCESS's occuring when verifying results in tests.
    // Bug in OCMock: https://github.com/erikdoe/ocmock/issues/147
    id<STLogger> _currentLogger;
    
    PKAssembly *result;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        _activeLogs = @[];
        _loggerClass = NSStringFromClass([STConsoleLogger class]);
        
        // The configuration runs in order: Default value, value from config file, value from environment, value from command line arg. 
        [self configurefromFile];
        [self configurefromArgs];
        
    }
    return self;
}

-(void) configurefromArgs {
    
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    
    // Process any environment variables.
    [processInfo.environment enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [self setValue:value forKey:key];
    }];
    
    // Process any command line arguments.
    [processInfo.arguments enumerateObjectsUsingBlock:^(NSString * _Nonnull arg, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *args = [arg componentsSeparatedByString:@"="];
        if ([args count] == 2) {
            [self setValue:args[1] forKey:args[0]];
        }
    }];
}

-(void) configurefromFile {

	// Get the config file.
	NSArray<NSBundle *> *appBundles = [NSBundle allBundles];
	NSURL *configUrl = nil;
	for (NSBundle *bundle in appBundles) {
		configUrl = [bundle URLForResource:@"StoryTellerConfig" withExtension:@"json"];
		if (configUrl != nil) {
			NSError *error = nil;
			NSLog(@"Story Teller: Config file found ...");
			NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:configUrl]
																						options:NSJSONReadingAllowFragments
																						  error:&error];
			if (error != nil) {
				@throw [NSException exceptionWithName:@"StoryTellerInvalidJSON" reason:[error localizedFailureReason] userInfo:nil];
			}

			[self setValuesForKeysWithDictionary:jsonData];
			return;
		}
	}
}

-(void) configure:(STStoryTeller *) storyTeller {

	Class loggerClass = objc_lookUpClass([_loggerClass UTF8String]);
	id<STLogger> newLogger = [[loggerClass alloc] init];
	if (newLogger == nil) {
		@throw [NSException exceptionWithName:@"StoryTellerUnknownClass" reason:[NSString stringWithFormat:@"Unknown class '%@'", _loggerClass] userInfo:nil];
	}

    if (self.logLineTemplate != nil) {
        newLogger.lineTemplate = self.logLineTemplate;
    }
    
    storyTeller.logger = newLogger;
    _currentLogger = newLogger;
    
    [_activeLogs enumerateObjectsUsingBlock:^(NSString *expression, NSUInteger idx, BOOL *stop) {
        [storyTeller startLogging:expression];
    }];
}

// Override KVC method to handle arrays in active logs.
-(void) setValue:(nullable id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"activeLogs"]) {
        _activeLogs = [_activeLogs arrayByAddingObjectsFromArray:value];
        return;
    }
    [super setValue:value forKey:key];
}

// Disabled default so we can load settings without having to check the names of properties.
// Unless it's for the log property, in which case we add it to the logs.
-(void) setValue:(id _Nullable) value forUndefinedKey:(NSString *) key {
    if ([key isEqualToString:@"log"]) {
        _activeLogs = [_activeLogs arrayByAddingObject:value];
        return;
    }
}

@end

NS_ASSUME_NONNULL_END
