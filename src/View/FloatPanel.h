/* FloatPanel */

#import "CatView.h"
#import "../Animator/CatAnimator.h"
#import "../Settings/CatSettings.h"

@interface FloatPanel : NSWindow
@property (nonatomic, strong, nonnull) CatAnimator *animator;
@property (nonatomic, strong, nonnull) CatView *view;
@property (nonatomic, strong, nonnull) CatSettings *settings;
@end
