//
//  MZLocalizationDefaultFactory.m
//  MZLocalizationSDK
//
//  Created by Mike Zhu on 29/12/2018.
//  Copyright © 2018 Mike Zhu. All rights reserved.
//

#import "MZLocalizationDefaultFactory.h"
#import "MZLocalizationManager.h"

@interface MZLocalizationDefaultFactory ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<MZLocalizationService>> *serviceCollections;

@end

@implementation MZLocalizationDefaultFactory

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialize localization default factory
        _serviceCollections = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public

- (id<MZLocalizationService>)serviceWithBundle:(NSBundle *)bundle {
    // Initiate presenter with SDK bundle
    NSString *bundlePath = bundle.bundlePath;
    if ([bundlePath length] == 0) {
        // Early return if bundle not found
        NSLog(@"[MZLocalizationDefaultFactory] Unable to init localization service due to bundle not found");
        return nil;
    }
    // Since bundle identifier is nullable, we will use bundle path as the key
    // If bundles are pointing to the same bundle path
    // We will only return one instance of localization service object
    id<MZLocalizationService> service = self.serviceCollections[bundlePath];
    if (!service) {
        service = [[MZLocalizationManager alloc] initWithBundle:bundle];
        self.serviceCollections[bundlePath] = service;
    }
    return service;
}

@end
