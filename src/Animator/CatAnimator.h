//
//  CatAnimator.h
//  Neko
//
//  Created by MeowCat on 2025/1/12.
//

#import <Foundation/Foundation.h>
#import "../Settings/CatSettings.h"
#import "../Animator/CatFrame.h"
#import "../Animator/CatState.h"

NS_ASSUME_NONNULL_BEGIN

@interface CatAnimator : NSObject
{
    unsigned char tickCount, stateCount;
    float moveDx, moveDy;
}

@property (nonatomic, strong, nonnull) CatState *catState;

@property (nonatomic) float mouseDistance;

@property (nonatomic, strong, nonnull) CatSettings *settings;

-(instancetype _Nonnull)initWithSettings:(CatSettings * _Nonnull)settings;

-(CatFrame* _Nonnull)tickWithX:(float)x
                             Y:(float)y
                        homeX:(float)mouseX
                        homeY:(float)mouseY;
@end

NS_ASSUME_NONNULL_END
