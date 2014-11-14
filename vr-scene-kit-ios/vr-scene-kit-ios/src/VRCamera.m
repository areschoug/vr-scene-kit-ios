//
//  VRCamera.m
//  vr-scene-kit-ios
//
//  Created by Andreas Areschoug on 12/11/14.
//  Copyright (c) 2014 com.poxpoxpox.vr-scene-kit-ios All rights reserved.
//

#import "VRCamera.h"


@interface VRCamera()

@property SCNNode *leftCameraNode;
@property SCNNode *rightCameraNode;

@end

@implementation VRCamera

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
    self.leftCameraNode = [SCNNode node];
    self.leftCameraNode.camera = [SCNCamera camera];
    [self addChildNode:self.leftCameraNode];
    
    self.rightCameraNode = [SCNNode node];
    self.rightCameraNode.camera = [SCNCamera camera];
    [self addChildNode:self.rightCameraNode];
    
}

-(void)setCameraPositionDiff:(CGFloat)cameraPositionDiff{
    _cameraPositionDiff = cameraPositionDiff;
    _leftCameraNode.position = SCNVector3Make(cameraPositionDiff * -1, 0, 0);
    _rightCameraNode.position = SCNVector3Make(cameraPositionDiff * 1, 0, 0);
}

@end
