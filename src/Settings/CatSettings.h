//
//  CatSettings.h
//  Neko
//
//  Created by MeowCat on 2025/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const _Nonnull kNumCats;
extern NSString * const _Nonnull kTransparencyRadius;
extern NSString * const _Nonnull kCenterTransparency;
extern NSString * const _Nonnull kCursorOffsetX;
extern NSString * const _Nonnull kCursorOffsetY;

@interface CatSettings: NSObject
@property (nonatomic) int numCats;
@property (nonatomic) int transparencyRadius;
@property (nonatomic) int centerTransparency;
@property (nonatomic) int cursorOffsetX;
@property (nonatomic) int cursorOffsetY;
+(instancetype) loadSettings;
-(void) save;
-(void) loadSettings;
@end

NS_ASSUME_NONNULL_END
