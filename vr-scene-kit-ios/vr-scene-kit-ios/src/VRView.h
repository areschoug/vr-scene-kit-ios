//
//  VRView.h
//  vr-scene-kit-ios
//
//  Created by Andreas Areschoug on 10/11/14.
//  Copyright (c) 2014 com.poxpoxpox.vr-scene-kit-ios All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

typedef enum {
    t_vr_camera_shader_passthrough,
    t_vr_camera_shader_pincushion_distortion,
}t_vr_camera_shader;

@class SCNScene,VRCamera;

@interface VRView : UIView

@property (nonatomic) SCNScene *scene;
@property (nonatomic) t_vr_camera_shader shaderType;

@property (nonatomic, readonly) VRCamera *camera;

@property (nonatomic, readonly) SCNView *leftSceneView;
@property (nonatomic, readonly) SCNView *rightSceneView;

@end
