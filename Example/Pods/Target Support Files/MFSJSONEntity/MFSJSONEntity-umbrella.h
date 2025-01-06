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

#import "MFSJSONEntity.h"
#import "MFSJSONEntityElementProtocol.h"
#import "MFSJSONEntityPropertyProtocol.h"
#import "NSObject+JSONEntity.h"
#import "NSObject+MFSJSONEntity.h"

FOUNDATION_EXPORT double MFSJSONEntityVersionNumber;
FOUNDATION_EXPORT const unsigned char MFSJSONEntityVersionString[];

