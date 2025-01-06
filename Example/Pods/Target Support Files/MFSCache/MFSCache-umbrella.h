#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MFSCache.h"
#import "MFSCacheUtility.h"
#import "NSData+MFSAES.h"
#import "NSJSONSerialization+MFSJSONString.h"
#import "NSString+MFSEncrypt.h"
#import "MFSCacheManager.h"
#import "MFSCacheStorage.h"
#import "MFSCacheStorageObject.h"

FOUNDATION_EXPORT double MFSCacheVersionNumber;
FOUNDATION_EXPORT const unsigned char MFSCacheVersionString[];

