/* MyPanel */

#import <Cocoa/Cocoa.h>
#import "MyView.h"

extern NSString * const kTransparencyRadius;
extern NSString * const kCenterTransparency;

@interface CatSettings: NSObject
@property (nonatomic) int transparencyRadius;
@property (nonatomic) int centerTransparency;
-(void) save;
-(void) loadSettings;
@end

@interface MyPanel : NSWindow
{
	unsigned char tickCount, stateCount;
	float moveDx, moveDy;
	id myTimer;
}

@property (nonatomic, strong, nonnull) NekoState *nekoState;
@property (nonatomic, strong, nonnull) MyView *view;
@property (nonatomic) float mouseDistance;
@property (nonatomic, strong, nonnull) CatSettings *settings;
@end
