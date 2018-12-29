//
//  NSError+Localization.m
//  MZLocalizationSDK
//
//  Created by Mike Zhu on 29/12/2018.
//  Copyright © 2018 Mike Zhu. All rights reserved.
//

#import "NSError+Localization.h"

static NSString *const MZErrorDomainSDK = @"com.mz.error.domain.sdk";

@implementation NSError (Localization)

+ (id)errorWithCode:(NSInteger)code reason:(NSString *)reason {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:reason, NSLocalizedFailureReasonErrorKey, nil];
    return [self errorWithDomain:MZErrorDomainSDK code:code userInfo:userInfo];
}

@end
