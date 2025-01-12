#import <objc/runtime.h>
#import "CatView.h"

@implementation CatView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		image = nil;
	}
	return self;
}

- (void)setImageTo:(NSImage*)theImage
{
	if(image == theImage)
		return;
	image = theImage;
	[self setNeedsDisplay:YES];
}

- (NSImage*)image
{
	return image;
}

- (void)drawRect:(NSRect)rect
{
    if(image) {
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationNone];
        [image drawAtPoint:NSMakePoint(0.0f, 0.0f) fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction: self.opacity];
    }
	//printf("draw %d\n", image);
}

@end
