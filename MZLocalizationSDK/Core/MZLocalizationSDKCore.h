//
//  MZLocalizationSDKCore.h
//  MZLocalizationSDK
//
//  Created by Mike Zhu on 29/12/2018.
//  Copyright © 2018 Mike Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MZLocalizationProvider;
@protocol MZLocalizationFactory;

NS_ASSUME_NONNULL_BEGIN

@interface MZLocalizationSDKCore : NSObject

@property (nonatomic, readonly, strong) id<MZLocalizationFactory> localizationFactory;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
