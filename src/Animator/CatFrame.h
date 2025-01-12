//
//  CatFrame.h
//  Neko
//
//  Created by MeowCat on 2025/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CatFrame : NSObject
@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic, strong, nonnull) NSImage *image;
@property (nonatomic) float opacity;
@end

NS_ASSUME_NONNULL_END
