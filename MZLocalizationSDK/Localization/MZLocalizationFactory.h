//
//  MZLocalizationFactory.h
//  MZLocalizationSDK
//
//  Created by Mike Zhu on 29/12/2018.
//  Copyright © 2018 Mike Zhu. All rights reserved.
//

/**
 * The protocol for internally get the instance of localization service
 */

#import "MZLocalizationService.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MZLocalizationFactory <NSObject>

/*!
 * @brief Initiate localization service with bundle
 * @param bundle SDK module bundle containing localization files
 * @return The instance of localization service
 */
- (nullable id<MZLocalizationService>)serviceWithBundle:(NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
