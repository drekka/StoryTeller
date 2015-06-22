//
//  STConfig.m
//  StoryTeller
//
//  Created by Derek Clarkson on 22/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STConfig.h"
#import "StoryTeller.h"
@class STConsoleLogger;

@interface STConfig ()
@property (nonatomic, assign) BOOL logAll;
@property (nonatomic, assign) BOOL logRoots;
@property (nonatomic, strong) NSArray<NSString *> *activeLogs;
@property (nonatomic, strong) NSString *loggerClass;
@end

@implementation STConfig

-(instancetype) init {
    self = [super init];
    if (self) {
        _logAll = NO;
        _logRoots = NO;
        _activeLogs = @[];
        _loggerClass = NSStringFromClass([STConsoleLogger class]);
        [self configurefromFile];
        [self configurefromArgs];
    }
    return self;
}

-(void) configurefromArgs {
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    [processInfo.arguments enumerateObjectsUsingBlock:^(NSString * __nonnull arg, NSUInteger idx, BOOL * __nonnull stop) {
        NSArray __nonnull *args = [arg componentsSeparatedByString:@"="];
        if ([args count] == 2) {
            [self setValue:args[1] forKeyPath:args[0]];
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
            break;
        }
    }
    if (configUrl == nil) {
        return;
    }

    NSError *error = nil;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:configUrl]
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
    if (error == nil) {
        [self setValuesForKeysWithDictionary:jsonData];
        return;
    }

    @throw [NSException exceptionWithName:@"StoryTeller" reason:[error localizedFailureReason] userInfo:nil];

}

-(void) configure:(StoryTeller __nonnull *) storyTeller {
    storyTeller.logAll = _logAll;
    storyTeller.logRoot = _logRoots;
    storyTeller.logger = [[NSClassFromString(_loggerClass) alloc] init];
    [_activeLogs enumerateObjectsUsingBlock:^(NSString * __nonnull key, NSUInteger idx, BOOL * __nonnull stop) {
        [storyTeller startLogging:key];
    }];
}

// DIsabled default so we can load settings without having to check the names of properties.
-(void) setValue:(nullable id)value forUndefinedKey:(nonnull NSString *)key {
}

@end
