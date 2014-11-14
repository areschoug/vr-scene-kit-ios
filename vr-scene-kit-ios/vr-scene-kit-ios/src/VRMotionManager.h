//
//  VRMotionManager.h
//  vr-scene-kit-ios
//
//  Created by Andreas Areschoug on 10/11/14.
//  Copyright (c) 2014 com.poxpoxpox.vr-scene-kit-ios All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

typedef void (^VRMotionManagerEulerAngles)(SCNVector3 vector);

@interface VRMotionManager : NSObject

+ (instancetype)motionManager;

-(void)start;
-(void)stop;

@property (weak) SCNNode *cameraNode;
@property (nonatomic, copy) void (^didUpdateEulerAngles)(SCNVector3 vector);


@end
