//
//  VRView.m
//  vr-scene-kit-ios
//
//  Created by Andreas Areschoug on 10/11/14.
//  Copyright (c) 2014 com.poxpoxpox.vr-scene-kit-ios All rights reserved.
//

#import "VRView.h"
#import "VRCamera.h"

static const float kCameraPositionDiff = 0.2;

@interface VRView()<SCNSceneRendererDelegate>

@property SCNView *leftSceneView;
@property SCNView *rightSceneView;

@property VRCamera *camera;
@property UIView *debugView;

@property UITapGestureRecognizer *trippleTapGesture;

@property EAGLContext *glContext;

@end


@implementation VRView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
    _leftSceneView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    _leftSceneView.userInteractionEnabled = NO;
    _leftSceneView.delegate = self;
    
    _rightSceneView = [[SCNView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    _rightSceneView.userInteractionEnabled = NO;
    [_rightSceneView setAutoenablesDefaultLighting:YES];
    _camera = [VRCamera node];
    _camera.cameraPositionDiff = kCameraPositionDiff;
    
    [self addSubview:_leftSceneView];
    [self addSubview:_rightSceneView];
    
    [self setShaderType:t_vr_camera_shader_pincushion_distortion];
    
}

#pragma mark - setter
-(void)setScene:(SCNScene *)scene{
    _scene = scene;

    [scene.rootNode addChildNode:_camera];
    
    _leftSceneView.scene = scene;
    _rightSceneView.scene = scene;
    
    _leftSceneView.pointOfView = _camera.leftCameraNode;
    _rightSceneView.pointOfView = _camera.rightCameraNode;
}

-(void)setShaderType:(t_vr_camera_shader)shaderType{
    _shaderType = shaderType;
    
    NSURL *url = nil;
    
    if (shaderType == t_vr_camera_shader_pincushion_distortion) {
        url = [[NSBundle mainBundle] URLForResource:@"Pincushion" withExtension:@"plist"];
    } else {
        url = [[NSBundle mainBundle] URLForResource:@"Passthrough" withExtension:@"plist"];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
    SCNTechnique *technique = [SCNTechnique techniqueWithDictionary:dict];
    self.leftSceneView.technique = technique;
    self.rightSceneView.technique = technique;
}

@end




