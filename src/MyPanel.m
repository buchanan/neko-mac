#import "MyPanel.h"

NSString * const kTransparencyRadius = @"transparencyRadius";
NSString * const kCenterTransparency = @"centerTransparency";

@implementation CatSettings
+(instancetype)loadSettings {
	CatSettings *res = [CatSettings new];
	[res loadSettings];
	return res;
}

-(void)loadSettings {
	self.transparencyRadius = (int) [NSUserDefaults.standardUserDefaults integerForKey:kTransparencyRadius];
	self.centerTransparency = (int) [NSUserDefaults.standardUserDefaults integerForKey:kCenterTransparency];
}

-(void) save {
	[NSUserDefaults.standardUserDefaults setInteger:self.transparencyRadius
											 forKey:kTransparencyRadius];
	[NSUserDefaults.standardUserDefaults setInteger:self.centerTransparency
											 forKey:kCenterTransparency];
}
@end

@implementation MyPanel
- (void)setStateTo:(NekoState *)theState
{
	if (self.nekoState == theState) {
		return;
	}
	//printf("state %d\n", theState);
	tickCount = 0;
	stateCount = 0;
	self.nekoState = theState;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)styleMask backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation
{
	self = [super initWithContentRect:contentRect
							styleMask:styleMask
							  backing:bufferingType
								defer:deferCreation];
	[self setLevel:NSStatusWindowLevel];
	self.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorFullScreenAuxiliary;
	[self setOpaque:NO];
	[self setCanHide:NO];
	[self setIgnoresMouseEvents:YES];
	[self setMovableByWindowBackground:NO];
	[self center];
	[self setBackgroundColor:[NSColor clearColor]];
	self.view = [[MyView alloc] init];
	self.contentView = self.view;
	[self orderFront:nil];
	self.settings = [CatSettings loadSettings];
	self.settings.centerTransparency = 80;
	self.settings.transparencyRadius = 200;
	[self setStateTo: NekoState.stop];
	[NSTimer scheduledTimerWithTimeInterval:0.125f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	return self;
}

- (void)calcDxDyForX:(float)x Y:(float)y
{
	float		MouseX, MouseY;
	float		DeltaX, DeltaY;
	float		Length;
	
	NSPoint p = [NSEvent mouseLocation];
	MouseX = p.x;
	MouseY = p.y;
	
	DeltaX = floor(MouseX - x - 16.0f);
	DeltaY = floor(MouseY - y);
	
	Length = hypotf(DeltaX, DeltaY);
	self.mouseDistance = Length;
	
	if (Length != 0.0f) {
		if (Length <= 13.0f) {
			moveDx = DeltaX;
			moveDy = DeltaY;
		} else {
			moveDx = (13.0f * DeltaX) / Length;
			moveDy = (13.0f * DeltaY) / Length;
		}
	} else {
		moveDx = moveDy = 0.0f;
	}
}

- (BOOL)isNekoMoveStart
{
	return moveDx > 6 || moveDx < -6 || moveDy > 6 || moveDy < -6;
}

- (void)advanceClock
{
	if (++tickCount >= 255) {
		tickCount = 0;
    }
	
    if (tickCount % 2 == 0) {
		if (stateCount < 255) {
			stateCount++;
		}
    }
}

- (void)NekoDirection
{
	NekoState   *newNekoState;
    double		LargeX, LargeY;
    double		Length;
    double		SinTheta;
	
    if (moveDx == 0.0f && moveDy == 0.0f) {
		newNekoState = NekoState.stop;
    } else {
		LargeX = (double)moveDx;
		LargeY = (double)moveDy;
		Length = sqrt(LargeX * LargeX + LargeY * LargeY);
		SinTheta = LargeY / Length;
		if (SinTheta > 0.9239) {
			newNekoState = NekoState.up;
		} else if (SinTheta > 0.3827) {
			newNekoState = moveDx > 0 ?
				NekoState.upright : NekoState.upleft;
		} else if (SinTheta > -0.3827) {
			newNekoState = moveDx > 0 ?
				NekoState.right : NekoState.left;
		} else if (SinTheta > -0.9239) {
			newNekoState = moveDx > 0 ?
				NekoState.dwright : NekoState.dwleft;
		} else {
			newNekoState = NekoState.down;
		}
    }
	
    [self setStateTo:newNekoState];
}

- (void)handleTimer:(NSTimer*)timer
{
	float x = [self frame].origin.x;
	float y = [self frame].origin.y;
	[self calcDxDyForX:x Y:y];
	BOOL isNekoMoveStart = [self isNekoMoveStart];
	if (self.nekoState != NekoState.sleep) {
		[self.view setImageTo:(NSImage*)[self.nekoState.images objectAtIndex:tickCount % [self.nekoState.images count]]];
	} else {
		[self.view setImageTo:(NSImage*)[self.nekoState.images objectAtIndex:(tickCount>>2) % [self.nekoState.images count]]];
	}
	[self advanceClock];
	
    if (self.nekoState == NekoState.stop) {
		if (isNekoMoveStart) {
			[self setStateTo:NekoState.awake];
			goto breakout;
		}
		if (stateCount < 4) {
			goto breakout;
		}
		/*if (moveDx < 0 && x <= 0) {
		[self setStateTo:l_togi];
		} else if (moveDx > 0 && x >= WindowWidth - 32) {
			[self setStateTo:r_togi];
		} else if (moveDy < 0 && y <= 0) {
			[self setStateTo:u_togi];
		} else if (moveDy > 0 && y >= WindowHeight - 32) {
			[self setStateTo:d_togi];
		} else {*/
		[self setStateTo:NekoState.mati];
		//}
	} else if (self.nekoState == NekoState.mati) {
		if (isNekoMoveStart) {
			[self setStateTo:NekoState.awake];
			goto breakout;
		}
		if (stateCount < 10) {
			goto breakout;
		}
		[self setStateTo:NekoState.kaki];
	} else if (self.nekoState == NekoState.kaki) {
		if (isNekoMoveStart) {
			[self setStateTo:NekoState.awake];
			goto breakout;
		}
		if (stateCount < 4) {
			goto breakout;
		}
		[self setStateTo:NekoState.akubi];
	} else if (self.nekoState == NekoState.akubi) {
		if (isNekoMoveStart) {
			[self setStateTo:NekoState.awake];
			goto breakout;
		}
		if (stateCount < 6) {
			goto breakout;
		}
		[self setStateTo:NekoState.sleep];
	} else if (self.nekoState == NekoState.sleep) {
		if (isNekoMoveStart) {
			[self setStateTo:NekoState.awake];
			goto breakout;
		}
	} else if (self.nekoState == NekoState.awake) {
		if (stateCount < 3) {
			goto breakout;
		}
		[self NekoDirection];	/* 猫が動く向きを求める */
	} else if (self.nekoState.kind == NekoStateKindMoving) {
		x += moveDx;
		y += moveDy;
		[self NekoDirection];
	} else if (self.nekoState.kind == NekoStateKindTogi) {
		if (isNekoMoveStart) {
			[self setStateTo:NekoState.awake];
			goto breakout;
		}
		if (stateCount < 10) {
			goto breakout;
		}
		[self setStateTo:NekoState.kaki];
	} else {
		/* Internal Error */
		[self setStateTo:NekoState.stop];
	}

	breakout:
	[self.view displayIfNeeded];
	[self setFrameOrigin:NSMakePoint(x, y)];
	
	// Update opacity of 🐱
	if (self.settings.transparencyRadius < self.mouseDistance) {
		self.view.opacity = 1.0;
	} else {
		float rate = self.mouseDistance / self.settings.transparencyRadius;
		float centerTransparency = self.settings.centerTransparency / 100.0;
		self.view.opacity = 1 - centerTransparency + rate * centerTransparency;
	}
}
@end
