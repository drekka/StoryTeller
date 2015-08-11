//
//  STConfig.m
//  StoryTeller
//
//  Created by Derek Clarkson on 22/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

@import ObjectiveC;

#import <PEGKit/PEGKit.h>

#import <StoryTeller/STConfig.h>
#import <StoryTeller/STStoryTeller.h>
#import <StoryTeller/STConsoleLogger.h>

NS_ASSUME_NONNULL_BEGIN

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
		[self configurefromFile];
		[self configurefromArgs];
	}
	return self;
}

-(void) configurefromArgs {
	NSProcessInfo *processInfo = [NSProcessInfo processInfo];
	[processInfo.arguments enumerateObjectsUsingBlock:^(NSString * _Nonnull arg, NSUInteger idx, BOOL * _Nonnull stop) {
		NSArray *args = [arg componentsSeparatedByString:@"="];
		if ([args count] == 2) {
			if ([@"logLineTemplate" isEqualToString:args[0]]) {
				self->_logLineTemplate = args[1];
			} else if ([@"loggerClass" isEqualToString:args[0]]) {
				self->_loggerClass = args[1];
			} else if ([@"log" isEqualToString:args[0]]) {
				self->_activeLogs = [self->_activeLogs arrayByAddingObject:args[1]];
			}
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
				@throw [NSException exceptionWithName:@"StoryTeller" reason:[error localizedFailureReason] userInfo:nil];
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
		@throw [NSException exceptionWithName:@"StoryTeller" reason:[NSString stringWithFormat:@"Unknown class '%@'", _loggerClass] userInfo:nil];
	}

	if (self.logLineTemplate != nil) {
		newLogger.lineTemplate = self.logLineTemplate;
	}

	storyTeller.logger = newLogger;
	_currentLogger = newLogger;

	[_activeLogs enumerateObjectsUsingBlock:^(NSString * _Nonnull expression, NSUInteger idx, BOOL * _Nonnull stop) {
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

// DIsabled default so we can load settings without having to check the names of properties.
-(void) setValue:(id _Nullable) value forUndefinedKey:(NSString *) key {
}

@end

NS_ASSUME_NONNULL_END
