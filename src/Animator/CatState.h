//
//  CatState.h
//  Neko
//
//  Created by MeowCat on 2025/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CatStateKind) {
    CatStateKindMalicious,
    CatStateKindMoving,
    CatStateKindTogi,
};

@interface CatState: NSObject
@property (nonatomic, readonly, retain) NSArray<NSImage *> *images;
@property (nonatomic, readonly, assign) CatStateKind kind;
-(instancetype)initWithImages:(NSArray<NSImage *> *)images
                         kind:(CatStateKind)kind;

NS_ASSUME_NONNULL_END
#define H(Name, _, __) \
@property (class, readonly, assign) CatState *Name;
#include "CatStates.def"
#undef H
@end
