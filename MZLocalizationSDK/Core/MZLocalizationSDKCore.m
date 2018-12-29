//
//  MZLocalizationSDKCore.m
//  MZLocalizationSDK
//
//  Created by Mike Zhu on 29/12/2018.
//  Copyright © 2018 Mike Zhu. All rights reserved.
//

#import "MZLocalizationSDKCore.h"
#import "MZLocalizationManager.h"
#import "MZLocalizationDefaultFactory.h"

@interface MZLocalizationSDKCore ()

@property (nonatomic, readwrite, strong) id<MZLocalizationFactory> localizationFactory;

@end

@implementation MZLocalizationSDKCore

#pragma mark - Initialize

+ (instancetype)sharedInstance {
    static MZLocalizationSDKCore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _localizationFactory = [[MZLocalizationDefaultFactory alloc] init];
    }
    return self;
}

@end
