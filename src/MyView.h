/* MyView */

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, NekoStateKind) {
    NekoStateKindMalicious,
    NekoStateKindMoving,
    NekoStateKindTogi,
};

@interface NekoState: NSObject
@property (nonatomic, readonly, retain) NSArray<NSImage *> *images;
@property (nonatomic, readonly, assign) NekoStateKind kind;
-(instancetype)initWithImages:(NSArray<NSImage *> *)images
                         kind:(NekoStateKind)kind;
#define H(Name, _, __) \
+(NekoState *)Name;
#include "CatStates.def"
#undef H
@end

@interface MyView : NSView
{
	NSImage *image;
}

- (NSImage*)image;
- (void)setImageTo:(NSImage*)theImage;
@property (nonatomic) float opacity;

@end
