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

#import "MFSIDDelegateHelper.h"
#import "MFSIdentifier.h"
#import "MFSKeyChain.h"
#import "MFSSafariIDManager.h"
#import "NSDictionary+MFSIDURLQuery.h"
#import "NSString+MFSIDURLEncoded.h"

FOUNDATION_EXPORT double MFSIdentifierVersionNumber;
FOUNDATION_EXPORT const unsigned char MFSIdentifierVersionString[];

