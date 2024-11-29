/* MyPanel */

#import <Cocoa/Cocoa.h>
#import "MyView.h"

extern NSString * const kTransparencyRadius;
extern NSString * const kCenterTransparency;

@interface CatSettings: NSObject
@property (nonatomic) int transparencyRadius;
@property (nonatomic) int centerTransparency;
-(void) save;
@end

@interface MyPanel : NSWindow
{
	NSArray *stop, *jare, *kaki, *akubi, *sleep, *awake, *u_move, *d_move,
	        *l_move, *r_move, *ul_move, *ur_move, *dl_move, *dr_move, *u_togi,
			*d_togi, *l_togi, *r_togi;
	
	id nekoState;
	unsigned char tickCount, stateCount;
	float moveDx, moveDy;
	id myTimer;
}
@property (nonatomic, strong, nonnull) MyView *view;
@property (nonatomic) float mouseDistance;
@property (nonatomic, strong, nonnull) CatSettings *settings;
@end
