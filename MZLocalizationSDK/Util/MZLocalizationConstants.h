//
//  MZLocalizationConstants.h
//  MZLocalizationSDK
//
//  Created by Mike Zhu on 29/12/2018.
//  Copyright © 2018 Mike Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - SDK localization service

/*!
 * @var MZLocalizationServiceSDKLanguageChangedNotification
 * @brief This notification is posted while current language of SDK has been changed
 * @discussion Interested parties may register such notification to receive current language key
 * For example:
 * (1) Client app has changed the current language
 * (2) Localization manager will broadcast the notification
 * (3) Interested parties will register and receive such notification with language key
 */
FOUNDATION_EXTERN NSString *const MZLocalizationServiceSDKLanguageChangedNotification;

/*!
 * @var MZLocalizationServiceSDKLanguageChangedKey
 * @brief SDK localization service language changed key
 */
FOUNDATION_EXTERN NSString *const MZLocalizationServiceSDKLanguageChangedKey;
