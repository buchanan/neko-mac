#import "MyView.h"
#import <objc/runtime.h>

// God curses those who speak all-upper-cased words,
// those who make things terrible again.
// Even when naming constants.
static NSDictionary<NSString *, NSString *> *kCatStateReuseMap = @{
    @"stop1": @"mati2"
};

@implementation NekoState
-(instancetype)initWithImages:(NSArray<NSImage *> *)images
                         kind:(NekoStateKind)kind
{
    if (self = [super init]) {
        _images = [images retain];
        _kind = kind;
    }
    return self;
}
#define H(Name, Length, Kind) \
+(NekoState *)Name \
{ \
    static NekoState *result = nil; \
    if (result == nil) { \
        NSBundle *bundle = [NSBundle mainBundle]; \
        NSMutableArray<NSImage *> *images = [NSMutableArray new]; \
        for (int i = 1; i <= Length; i++) {\
            NSString *key = [NSString stringWithFormat:@"" #Name "%d", i]; \
            key = kCatStateReuseMap[key] ?: key; \
            /* NSLog(@"k: %@", key); */ \
            [images addObject:[ \
                [NSImage alloc] initWithContentsOfFile:[ \
                    bundle pathForResource:key \
                                    ofType:@"gif" \
                ] \
            ]]; \
        } \
        result = [[NekoState alloc] initWithImages: images \
                                              kind: Kind];\
    } \
    return result; \
}
#include "CatStates.def"
#undef H
@end

@implementation MyView

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
