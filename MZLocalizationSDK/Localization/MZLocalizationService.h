//
//  MZLocalizationService.h
//  MZLocalizationSDK
//
//  Created by Mike Zhu on 29/12/2018.
//  Copyright © 2018 Mike Zhu. All rights reserved.
//

/**
 * The protocol for providing localization service
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MZLocalizationService <NSObject>

/*!
 * @brief Add additional language which has not been supported yet
 * @param language Localization language
 * @param fileURL File URL of ".strings" file
 * @param error Error when adding another language
 * @return YES if language is successfully added
 * @return NO if language failed to be added
 * @discussion If client app needs to add an additional language,
 * client app needs to prepare a ".strings" file with all the keys and translations
 */
- (BOOL)addAdditionalLanguage:(NSString *)language
       withTranslationFileURL:(NSURL *)fileURL
                        error:(NSError **)error;

/*!
 * @brief Update the translations of an existing language
 * @param language Localization language
 * @param fileURL File URL of ".strings" file
 * @param error Error when updating the translations
 * @return YES if language is successfully updated
 * @return NO if language failed to be updated
 * @discussion If client app needs to update the translations of some specific keys of an existing language,
 * client app only needs to prepare a ".strings" file with the specific keys and translations to be updated.
 * In other words, client app does not need to prepare all the keys and translations
 */
- (BOOL)updateTranslationsForLanguage:(NSString *)language
               withTranslationFileURL:(NSURL *)fileURL
                                error:(NSError **)error;

/*!
 * @brief Switch the current language at runtime
 * @param language Localization language
 * @param error Error when switch current language
 * @return YES if language is successfully switched
 * @return NO if language failed to be switched
 */
- (BOOL)switchCurrentLanguage:(NSString *)language
                        error:(NSError **)error;

/*!
 * @return All localization languages supported by MZSDK
 */
- (NSArray *)allSupportedLocalizationLanguages;

/*!
 * @return Current localization language
 */
- (NSString *)currentLocalizationLanguage;

/*!
 * @return Default localization language
 */
- (NSString *)defaultLocalizationLanguage;

/*!
 * @brief Provide localized string
 * @param key Locale key
 * @return Localized string for the key
 * @warning User shall ensure the folder structure as follows
 * __ Localization
 *   |__ en.lproj
 *   |   |__ Localizable.strings
 *   |
 *   |__ ja.lproj
 *       |__ Localizable.strings
 */
- (nullable NSString *)localizedStringWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
