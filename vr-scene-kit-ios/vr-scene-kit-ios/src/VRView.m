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

@interface VRView()

@property SCNView *leftSceneView;
@property SCNView *rightSceneView;

@property VRCamera *camera;

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
    
    _rightSceneView = [[SCNView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    _rightSceneView.userInteractionEnabled = NO;
    _camera = [VRCamera node];
    _camera.cameraPositionDiff = kCameraPositionDiff;
    
    [self addSubview:_leftSceneView];
    [self addSubview:_rightSceneView];
    
    [self setShaderType:t_vr_camera_shader_pincushion_distortion];
    
}

#pragma mark - setter
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    _leftSceneView.backgroundColor = backgroundColor;
    _rightSceneView.backgroundColor = backgroundColor;
}

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
    
    NSString *filename = nil;
    
    if (shaderType == t_vr_camera_shader_pincushion_distortion) {
        filename = @"Pincushion";
    } else {
        filename = @"Passthrough";
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
    
    [self setTechnique:[SCNTechnique techniqueWithDictionary:dict]];
}

-(void)setTechnique:(SCNTechnique *)technique{
    _technique = technique;
    _leftSceneView.technique = technique;
    _rightSceneView.technique = technique;
}

-(void)setAutoenablesDefaultLighting:(BOOL)autoenablesDefaultLighting{
    _autoenablesDefaultLighting = autoenablesDefaultLighting;
    _leftSceneView.autoenablesDefaultLighting = autoenablesDefaultLighting;
    _rightSceneView.autoenablesDefaultLighting = autoenablesDefaultLighting;
}

@end




