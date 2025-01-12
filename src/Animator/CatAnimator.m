//
//  CatAnimator.m
//  Neko
//
//  Created by MeowCat on 2025/1/12.
//

#import "CatAnimator.h"
#import "CatFrame.h"

@implementation CatAnimator
- (instancetype)initWithSettings:(CatSettings *)settings
{
    self = [super init];
    if (!self) { return self; }
    self.settings = settings;
    [self setStateTo: CatState.stop];
    return self;
}

- (void)setStateTo:(CatState *)theState
{
    if (self.catState == theState) {
        return;
    }
    //printf("state %d\n", theState);
    tickCount = 0;
    stateCount = 0;
    self.catState = theState;
}

- (void)calcDxDyForX:(float)x
                   Y:(float)y
              mouseX:(float)mouseX
              mouseY:(float)mouseY
{
    float        DeltaX, DeltaY;
    float        Length;
    
    DeltaX = floor(mouseX - x - 16.0f);
    DeltaY = floor(mouseY - y);
    
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
    CatState   *newCatState;
    double        LargeX, LargeY;
    double        Length;
    double        SinTheta;
    
    if (moveDx == 0.0f && moveDy == 0.0f) {
        newCatState = CatState.stop;
    } else {
        LargeX = (double)moveDx;
        LargeY = (double)moveDy;
        Length = sqrt(LargeX * LargeX + LargeY * LargeY);
        SinTheta = LargeY / Length;
        if (SinTheta > 0.9239) {
            newCatState = CatState.up;
        } else if (SinTheta > 0.3827) {
            newCatState = moveDx > 0 ?
                CatState.upright : CatState.upleft;
        } else if (SinTheta > -0.3827) {
            newCatState = moveDx > 0 ?
                CatState.right : CatState.left;
        } else if (SinTheta > -0.9239) {
            newCatState = moveDx > 0 ?
                CatState.dwright : CatState.dwleft;
        } else {
            newCatState = CatState.down;
        }
    }
    
    [self setStateTo:newCatState];
}

- (CatFrame*)tickWithX:(float)x
                     Y:(float)y
                mouseX:(float)mouseX
                mouseY:(float)mouseY
{
    [self calcDxDyForX:x Y:y mouseX:mouseX mouseY:mouseY];
    BOOL isNekoMoveStart = [self isNekoMoveStart];
    CatFrame *result = [CatFrame new];
    if (self.catState != CatState.sleep) {
        result.image = (NSImage*)[self.catState.images objectAtIndex:tickCount % [self.catState.images count]];
    } else {
        result.image = (NSImage*)[self.catState.images objectAtIndex:(tickCount>>2) % [self.catState.images count]];
    }
    [self advanceClock];
    
    if (self.catState == CatState.stop) {
        if (isNekoMoveStart) {
            [self setStateTo:CatState.awake];
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
        [self setStateTo:CatState.mati];
        //}
    } else if (self.catState == CatState.mati) {
        if (isNekoMoveStart) {
            [self setStateTo:CatState.awake];
            goto breakout;
        }
        if (stateCount < 10) {
            goto breakout;
        }
        [self setStateTo:CatState.kaki];
    } else if (self.catState == CatState.kaki) {
        if (isNekoMoveStart) {
            [self setStateTo:CatState.awake];
            goto breakout;
        }
        if (stateCount < 4) {
            goto breakout;
        }
        [self setStateTo:CatState.akubi];
    } else if (self.catState == CatState.akubi) {
        if (isNekoMoveStart) {
            [self setStateTo:CatState.awake];
            goto breakout;
        }
        if (stateCount < 6) {
            goto breakout;
        }
        [self setStateTo:CatState.sleep];
    } else if (self.catState == CatState.sleep) {
        if (isNekoMoveStart) {
            [self setStateTo:CatState.awake];
            goto breakout;
        }
    } else if (self.catState == CatState.awake) {
        if (stateCount < 3) {
            goto breakout;
        }
        [self NekoDirection];    /* 猫が動く向きを求める */
    } else if (self.catState.kind == CatStateKindMoving) {
        x += moveDx;
        y += moveDy;
        [self NekoDirection];
    } else if (self.catState.kind == CatStateKindTogi) {
        if (isNekoMoveStart) {
            [self setStateTo:CatState.awake];
            goto breakout;
        }
        if (stateCount < 10) {
            goto breakout;
        }
        [self setStateTo:CatState.kaki];
    } else {
        /* Internal Error */
        [self setStateTo:CatState.stop];
    }

    breakout:
    result.x = x;
    result.y = y;
    // Update opacity of 🐱
    if (self.settings.transparencyRadius < self.mouseDistance) {
        result.opacity = 1.0;
    } else {
        float rate = self.mouseDistance / self.settings.transparencyRadius;
        float centerTransparency = self.settings.centerTransparency / 100.0;
        result.opacity = 1 - centerTransparency + rate * centerTransparency;
    }
    return result;
}
@end
