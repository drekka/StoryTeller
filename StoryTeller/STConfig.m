//
//  STConfig.m
//  StoryTeller
//
//  Created by Derek Clarkson on 22/06/2015.
//  Copyright © 2015 Derek Clarkson. All rights reserved.
//

#import "STConfig.h"
#import "StoryTeller.h"

@implementation STConfig

-(instancetype) init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(void) configurefromArgs:(StoryTeller __nonnull *) storyTeller {
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    [processInfo.arguments enumerateObjectsUsingBlock:^(NSString * __nonnull arg, NSUInteger idx, BOOL * __nonnull stop) {
        NSArray __nonnull *args = [arg componentsSeparatedByString:@"="];
        if ([args count] == 2) {
            [self setStoryteller:storyTeller value:args[1] forKeyPath:args[0]];
        }
    }];
}

-(void) configurefromFile:(StoryTeller __nonnull *) storyTeller {

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
    if (error != nil) {
        @throw [NSException exceptionWithName:@"StoryTeller" reason:[error localizedFailureReason] userInfo:nil];
    }

    // Now set the values.
    [jsonData enumerateKeysAndObjectsUsingBlock:^(id  __nonnull key, id  __nonnull obj, BOOL * __nonnull stop) {
        [self setStoryteller:storyTeller value:obj forKeyPath:key];
    }];

}

-(void) setStoryteller:(StoryTeller *) storyTeller value:(nullable id)value forKeyPath:(nonnull NSString *)key {
    [storyTeller setValue:value forKeyPath:key];
}


-(void) configure:(StoryTeller __nonnull *) storyTeller {
    [self configurefromFile:storyTeller];
    [self configurefromArgs:storyTeller];
}

@end
