//
//  VRMotionManager.m
//  vr-scene-kit-ios
//
//  Created by Andreas Areschoug on 10/11/14.
//  Copyright (c) 2014 com.poxpoxpox.vr-scene-kit-ios All rights reserved.
//

#import "VRMotionManager.h"
#import <CoreMotion/CoreMotion.h>

@interface VRMotionManager()

@property CMMotionManager *motionManager;

@end


@implementation VRMotionManager

+ (instancetype)motionManager{
    return [[[self class] alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    _motionManager = [[CMMotionManager alloc] init];
}

#pragma mark - Actions
-(void)start {
    
    __weak VRMotionManager *ws = self;
    
    [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
#pragma TODO: This needs to be tested
            SCNVector3 rotation;
            BOOL fancyMath = NO;
            
            if (fancyMath) {
                
                rotation = SCNVector3Make(deviceMotion.attitude.roll, deviceMotion.attitude.pitch, deviceMotion.attitude.yaw);
                
            } else {
                
                SCNVector3 referenceGravityVector = SCNVector3Make(-1, 0, 0);
                SCNVector3 currentGravityVector;
                SCNVector3 sideTiltVector;
                
                currentGravityVector = SCNVector3Make(deviceMotion.gravity.x, 0 , deviceMotion.gravity.z);
                sideTiltVector = SCNVector3Make(deviceMotion.gravity.x, deviceMotion.gravity.y, 0);
                
                currentGravityVector = SCNVector3Normalize(currentGravityVector);
                sideTiltVector = SCNVector3Normalize(sideTiltVector);
                
                float sideTiltAngle = SCNVector3AngleBetween(sideTiltVector, referenceGravityVector);
                float verticalAngle = SCNVector3AngleBetween(currentGravityVector, referenceGravityVector);
                
                if(isnan(sideTiltAngle)) sideTiltAngle = 0;
                if(isnan(verticalAngle)) verticalAngle = 0;
                
                if(currentGravityVector.z < 0) verticalAngle = -verticalAngle;
                if(sideTiltVector.y > 0) sideTiltAngle = -sideTiltAngle;
                
                rotation = SCNVector3Make(verticalAngle * -1, (deviceMotion.attitude.yaw + M_PI) * -1,-sideTiltAngle);
            }
            
            if (ws.didUpdateEulerAngles) ws.didUpdateEulerAngles(rotation);
            if (ws.cameraNode) [ws.cameraNode setEulerAngles:rotation];
        });
        
    }];
}

-(void)stop {
    [_motionManager stopDeviceMotionUpdates];
}

#pragma mark - Vector math

SCNVector3 SCNVector3Normalize(SCNVector3 v) {
    GLfloat len = SCNVector3Length(v);
    if (len == 0.0) return v;
    
    SCNVector3 normal;
    normal.x = v.x / len;
    normal.y = v.y / len;
    normal.z = v.z / len;
    return normal;
}

float SCNVector3AngleBetween(SCNVector3 vector1, SCNVector3 vector2) {
    float l1 = SCNVector3Length(vector1);
    float l2 = SCNVector3Length(vector2);
    if(l1 == 0 || l2 == 0) return 0;
    return acosf(SCNVector3Dot(vector1, vector2)/(l1*l2));
}

GLfloat SCNVector3Length(SCNVector3 v) {
    GLfloat x = v.x;
    GLfloat y = v.y;
    GLfloat z = v.z;
    return sqrtf((x * x) + (y * y) + (z * z));
}

GLfloat SCNVector3Dot(SCNVector3 v1, SCNVector3 v2) {
    return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z);
}

@end
