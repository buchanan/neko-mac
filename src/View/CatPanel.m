#import "CatPanel.h"

@interface CatView : NSView
@property (nonatomic, strong, nullable) NSImage *image;
@property (nonatomic) float opacity;
@end

@interface CatPanel ()
@property (nonatomic) float offsetX;
@property (nonatomic) float offsetY;
@property (nonatomic, strong, nonnull) CatView *view;
@property (nonatomic, strong, nullable) NSTimer *timer;
@end

@implementation CatView

- (void)drawRect:(NSRect)rect
{
	if (self.image) {
		[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationNone];
		[self.image drawAtPoint:NSMakePoint(0.0f, 0.0f) fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction: self.opacity];
	}
}

@end

@implementation CatPanel
- (instancetype)initWithContentRect:(NSRect)contentRect
						  styleMask:(NSWindowStyleMask)styleMask
							backing:(NSBackingStoreType)bufferingType
							  defer:(BOOL)deferCreation
							offsetX:(CGFloat)offsetX
							offsetY:(CGFloat)offsetY;
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
	self.releasedWhenClosed = NO;
	self.offsetX = offsetX;
	self.offsetY = offsetY;
	self.view = [[CatView alloc] init];
	self.settings = [CatSettings loadSettings];
	self.cat = [[CatAnimator alloc] initWithSettings: _settings];
	self.contentView = self.view;
	[self orderFront:nil];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.125f
												  target:self
												selector:@selector(handleTimer:)
												userInfo:nil
												 repeats:YES];
	return self;
}

- (void)close
{
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
	[super close];
}

- (void)handleTimer:(NSTimer*)timer
{
	NSPoint p = [NSEvent mouseLocation];
	CatFrame *frame = \
	[self.cat tickWithX:[self frame].origin.x
						   Y:[self frame].origin.y
					   homeX: self.offsetX + p.x
					   homeY: self.offsetY + p.y];
	self.view.image = frame.image;
	self.view.needsDisplay = YES;
	self.view.opacity = frame.opacity;
	[self.view displayIfNeeded];
	self.frameOrigin = NSMakePoint(frame.x, frame.y);
}
@end
