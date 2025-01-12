#import "FloatPanel.h"

@implementation FloatPanel
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
	self.view = [[CatView alloc] init];
	self.settings = [CatSettings loadSettings];
	self.animator = [[CatAnimator alloc] initWithSettings: _settings];
	self.contentView = self.view;
	[self orderFront:nil];
	[NSTimer scheduledTimerWithTimeInterval:0.125f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	return self;
}


- (void)handleTimer:(NSTimer*)timer
{
	NSPoint p = [NSEvent mouseLocation];
	CatFrame *frame = [self.animator
					   tickWithX:[self frame].origin.x
					           Y:[self frame].origin.y
						  mouseX: p.x
					      mouseY: p.y];
	[self.view setImageTo:frame.image];
	self.view.opacity = frame.opacity;
	[self.view displayIfNeeded];
	[self setFrameOrigin:NSMakePoint(frame.x, frame.y)];
}
@end
