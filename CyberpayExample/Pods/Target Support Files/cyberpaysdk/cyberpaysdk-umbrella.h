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

#import "cyberpaysdk.h"

FOUNDATION_EXPORT double cyberpaysdkVersionNumber;
FOUNDATION_EXPORT const unsigned char cyberpaysdkVersionString[];

