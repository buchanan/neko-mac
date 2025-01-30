//
//  CatState.m
//  Neko
//
//  Created by MeowCat on 2025/1/12.
//

#import "CatState.h"

// God curses those who speak all-upper-cased words,
// those who make things terrible again.
// Even when naming constants.
static NSDictionary<NSString *, NSString *> *kCatStateReuseMap = @{
    @"stop1": @"mati2"
};

@implementation CatState
-(instancetype)initWithImages:(NSArray<NSImage *> *)images
                         kind:(CatStateKind)kind
{
    if (self = [super init]) {
        _images = images;
        _kind = kind;
    }
    return self;
}
#define H(Name, Length, Kind) \
+(CatState *)Name \
{ \
    static CatState *result = nil; \
    if (result == nil) { \
        NSBundle *bundle = [NSBundle mainBundle]; \
        NSMutableArray<NSImage *> *images = [NSMutableArray new]; \
        for (int i = 1; i <= Length; i++) {\
            NSString *key = [NSString stringWithFormat:@"" #Name "%d", i]; \
            key = kCatStateReuseMap[key] ?: key; \
            /* NSLog(@"k: %@", key); */ \
            [images addObject:[ \
                [NSImage alloc] initWithContentsOfFile:[ \
                    bundle pathForResource:key \
                                    ofType:@"gif" \
                ] \
            ]]; \
        } \
        result = [[CatState alloc] initWithImages: images \
                                              kind: Kind];\
    } \
    return result; \
}
#include "CatStates.def"
#undef H
@end
