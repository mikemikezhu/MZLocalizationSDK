//
//  NSError+Localization.h
//  MZLocalizationSDK
//
//  Created by Mike Zhu on 29/12/2018.
//  Copyright © 2018 Mike Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MZErrorCode) {
    MZErrorCodeTranslationsNotFound = 1001,
    MZErrorCodeLanguageAlreadySupported,
    MZErrorCodeLanguageNotSupported
};

@interface NSError (Localization)

+ (id)errorWithCode:(NSInteger)code reason:(NSString *)reason;

@end

NS_ASSUME_NONNULL_END
