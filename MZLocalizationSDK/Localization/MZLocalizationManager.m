//
//  MZLocalizationManager.m
//  MZLocalizationSDK
//
//  Created by Mike Zhu on 29/12/2018.
//  Copyright © 2018 Mike Zhu. All rights reserved.
//

#import "MZLocalizationManager.h"
#import "MZLocalizationConstants.h"
#import "NSError+Localization.h"

static NSString *const MZLocalizationManagerLanguageBase = @"Base";
static NSString *const MZLocalizationManagerLanguageEnglish = @"en";

static NSString *const MZLocalizationManagerTableName = @"Localizable";

@interface MZLocalizationManager ()

@property (nonatomic, strong) NSBundle *bundle;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary *> *customizedLocalizations;
@property (nonatomic, strong) NSMutableArray *allSupportedLanguages;
@property (nonatomic, strong) NSString *currentLanguage;

@end

@implementation MZLocalizationManager

#pragma mark - Initialize

- (instancetype)initWithBundle:(NSBundle *)bundle {
    self = [super init];
    if (self) {
        // Initialize localization manager
        _bundle = bundle;

        _customizedLocalizations = [[NSMutableDictionary alloc] init];
        _allSupportedLanguages = [[NSMutableArray alloc] init];

        for (NSString *localization in [bundle localizations]) {
            if (![localization isEqualToString:MZLocalizationManagerLanguageBase]) {
                [_allSupportedLanguages addObject:localization];
            }
        }

        _currentLanguage = [self defaultLocalizationLanguage];
    }
    return self;
}

#pragma mark - Public

- (BOOL)addAdditionalLanguage:(NSString *)language
       withTranslationFileURL:(NSURL *)fileURL
                        error:(NSError **)error {
    // Add new language
    if ([self languageIsSupported:language]) {
        // Already supported, early return
        NSString *reason = [NSString stringWithFormat:@"Language %@ is already supported", language];
        *error = [NSError errorWithCode:MZErrorCodeLanguageAlreadySupported
                                 reason:reason];
        return NO;
    }

    NSDictionary *translations = [NSDictionary dictionaryWithContentsOfURL:fileURL];
    if (!translations) {
        NSString *reason = [NSString stringWithFormat:@"Translations not found for file URL %@", fileURL];
        *error = [NSError errorWithCode:MZErrorCodeTranslationsNotFound
                                 reason:reason];
        return NO;
    }

    [self.allSupportedLanguages addObject:language];
    self.customizedLocalizations[language] = translations;
    return YES;
}

- (BOOL)updateTranslationsForLanguage:(NSString *)language
               withTranslationFileURL:(NSURL *)fileURL
                                error:(NSError **)error {
    // Update translations
    if (![self languageIsSupported:language]) {
        // Not supported, early return
        NSString *reason = [NSString stringWithFormat:@"Language %@ is not supported", language];
        *error = [NSError errorWithCode:MZErrorCodeLanguageNotSupported
                                 reason:reason];
        return NO;
    }

    NSDictionary *translations = [NSDictionary dictionaryWithContentsOfURL:fileURL];
    if (!translations) {
        NSString *reason = [NSString stringWithFormat:@"Translations not found for file URL %@", fileURL];
        *error = [NSError errorWithCode:MZErrorCodeTranslationsNotFound
                                 reason:reason];
        return NO;
    }

    // Client app may update translations multiple times of a specific language
    // Therefore, need to check whether client app has previously updated translations for such language
    NSDictionary *previousTranslations = self.customizedLocalizations[language];
    if (previousTranslations) {
        // Need to overwrite the previous translations with the specific keys
        NSMutableDictionary *updatedTranslations = [previousTranslations mutableCopy];
        [translations enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *updatedTranslation, BOOL *stop) {
            updatedTranslations[key] = updatedTranslation;
        }];
        translations = [updatedTranslations copy];
    }

    self.customizedLocalizations[language] = translations;
    return YES;
}

- (BOOL)switchCurrentLanguage:(NSString *)language
                        error:(NSError **)error {
    // Switch current language
    if (![self languageIsSupported:language]) {
        NSString *reason = [NSString stringWithFormat:@"Language %@ is not supported", language];
        *error = [NSError errorWithCode:MZErrorCodeLanguageNotSupported
                                 reason:reason];
        return NO;
    }

    NSDictionary *userInfo = @{MZLocalizationServiceSDKLanguageChangedKey : language};
    [[NSNotificationCenter defaultCenter] postNotificationName:MZLocalizationServiceSDKLanguageChangedNotification
                                                        object:self
                                                      userInfo:userInfo];

    self.currentLanguage = language;
    return YES;
}

- (NSArray *)allSupportedLocalizationLanguages {
    // All localization languages
    return [self.allSupportedLanguages copy];
}

- (NSString *)currentLocalizationLanguage {
    // Current language
    return self.currentLanguage;
}

- (NSString *)defaultLocalizationLanguage {
    // Default language
    NSString *systemLanguage = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    return [self languageIsSupported:systemLanguage] ? systemLanguage : MZLocalizationManagerLanguageEnglish;
}

- (NSDictionary<NSString *, NSDictionary *> *)allCustomizedLocalizations {
    // All customized localizations
    return [self.customizedLocalizations copy];
}

- (NSString *)localizedStringWithKey:(NSString *)key {
    // Check whether client app has customized the localization
    NSString *localizedString = [self customizedLocalizationWithKey:key];
    if ([localizedString length]) {
        return localizedString;
    }

    // Check bundle directory provided by each module
    NSString *currentLanguage = [self currentLocalizationLanguage];
    localizedString = [self localizedStringWithKey:key forLanguage:currentLanguage];
    return localizedString;
}

#pragma mark - Private

- (BOOL)languageIsSupported:(NSString *)language {
    // Check if language is supported by SDK
    NSArray *languages = [self allSupportedLocalizationLanguages];
    return [languages containsObject:language];
}

- (NSString *)customizedLocalizationWithKey:(NSString *)key {
    // Localization customized by client app
    NSDictionary *customizedLocalizations = [self allCustomizedLocalizations];
    NSString *language = [self currentLocalizationLanguage];
    NSDictionary *translations = customizedLocalizations[language];
    return [key length] ? translations[key] : nil;
}

- (NSString *)localizedStringWithKey:(NSString *)key forLanguage:(NSString *)language {
    // Return localized string for language in a given bundle
    NSString *localizedString;
    if ([key length]) {
        NSString *directory = [NSString stringWithFormat:@"%@.lproj", language];
        NSString *directoryPath = [[self.bundle bundlePath] stringByAppendingPathComponent:directory];
        NSBundle *languageBundle = [NSBundle bundleWithPath:directoryPath];
        localizedString = NSLocalizedStringFromTableInBundle(key, MZLocalizationManagerTableName, languageBundle, nil);
        if ([localizedString isEqualToString:key]) {
            // If key is not found and value is an empty string, returns key
            NSLog(@"[MZLocalizationManager] Key: %@ is not found for language: %@", key, language);
        }
    }
    return localizedString;
}

@end
