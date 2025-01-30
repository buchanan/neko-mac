/* CatPanel */

#import <Cocoa/Cocoa.h>
#import "../Animator/CatAnimator.h"
#import "../Settings/CatSettings.h"

@interface CatPanel : NSWindow
@property (nonatomic, strong, nonnull) CatAnimator *cat;
@property (nonatomic, strong, nonnull) CatSettings *settings;
- (instancetype _Nonnull)initWithContentRect:(NSRect)contentRect
                                   styleMask:(NSWindowStyleMask)styleMask
                                     backing:(NSBackingStoreType)bufferingType
                                       defer:(BOOL)deferCreation
                                     offsetX:(CGFloat)offsetX
                                     offsetY:(CGFloat)offsetY;
@end
