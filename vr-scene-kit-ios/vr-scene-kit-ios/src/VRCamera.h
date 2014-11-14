//
//  VRCamera.h
//  vr-scene-kit-ios
//
//  Created by Andreas Areschoug on 12/11/14.
//  Copyright (c) 2014 com.poxpoxpox.scenekit. All rights reserved.
//

#import <SceneKit/SceneKit.h>


@interface VRCamera : SCNNode

@property (nonatomic, readwrite) CGFloat cameraPositionDiff;

@property (nonatomic, readonly) SCNNode *leftCameraNode;
@property (nonatomic, readonly) SCNNode *rightCameraNode;

@end