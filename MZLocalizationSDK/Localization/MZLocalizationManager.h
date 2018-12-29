//
//  MZLocalizationManager.h
//  MZLocalizationSDK
//
//  Created by Mike Zhu on 29/12/2018.
//  Copyright © 2018 Mike Zhu. All rights reserved.
//

#import "MZLocalizationService.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZLocalizationManager : NSObject <MZLocalizationService>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithBundle:(NSBundle *)bundle NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
