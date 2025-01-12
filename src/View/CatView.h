/* CatView */

#import <Cocoa/Cocoa.h>

@interface CatView : NSView
{
	NSImage *image;
}

- (NSImage*)image;
- (void)setImageTo:(NSImage*)theImage;
@property (nonatomic) float opacity;

@end
