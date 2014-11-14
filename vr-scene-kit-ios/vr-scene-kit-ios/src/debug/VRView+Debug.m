//
//  VRView+Debug.m
//  vr-scene-kit-ios
//
//  Created by Andreas Areschoug on 12/11/14.
//  Copyright (c) 2014 com.poxpoxpox.vr-scene-kit-ios All rights reserved.
//

#import "VRView+Debug.h"
#import "VRView.h"
#import "VRCamera.h"

@interface VRDebugView : UIView

-(instancetype)initWithVRView:(VRView *)view;

@property UISlider *eyeDiffSlider;
@property UILabel *eyeDiffValueLabel;

@property UISwitch *shaderSwitch;
@property UILabel *shaderValueLabel;
@property UISwitch *orthograpicSwitch;
@property UILabel *orthograpicValueLabel;

@property (nonatomic, copy) void (^didUpdateEyeDiff)(float diff);
@property (nonatomic, copy) void (^didUpdateShader)(BOOL passThrough);
@property (nonatomic, copy) void (^didChangeCamera)(BOOL orthographicProjection);
@property (nonatomic, copy) void (^didClose)();

@property VRView *view;

@end

@implementation VRView (Debug)

-(void)enableDebugMode{
    UITapGestureRecognizer *trippleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDebug:)];
    trippleTapGesture.numberOfTapsRequired = 3;
    [self addGestureRecognizer:trippleTapGesture];
}

#pragma mark debug

-(void)showDebug:(id)sender{
    if ([self viewWithTag:1337]) return;
    
    self.leftSceneView.showsStatistics = YES;
    self.rightSceneView.showsStatistics = YES;
    
    VRDebugView *debugView = [[VRDebugView alloc] initWithVRView:self];
    debugView.tag = 1337;
    [self addSubview:debugView];
    
    __weak VRView *ws = self;
    [((VRDebugView *) debugView) setDidClose:^{
        ws.leftSceneView.showsStatistics = NO;
        ws.rightSceneView.showsStatistics = NO;
    }];
    
    [((VRDebugView *) debugView) setDidUpdateEyeDiff:^(float cameraDiff) {
        ws.camera.cameraPositionDiff = cameraDiff;
    }];
    
    [((VRDebugView *) debugView) setDidUpdateShader:^(BOOL passthrough) {
        [self setShaderType:passthrough ? t_vr_camera_shader_passthrough : t_vr_camera_shader_pincushion_distortion];
    }];
    
    [((VRDebugView *) debugView) setDidChangeCamera:^(BOOL camera) {
        ws.camera.leftCameraNode.camera.usesOrthographicProjection = camera;
        ws.camera.rightCameraNode.camera.usesOrthographicProjection = camera;
        ws.camera.leftCameraNode.camera.orthographicScale = 5;
        ws.camera.rightCameraNode.camera.orthographicScale = 5;
    }];
    
}

@end



#pragma mark -
#pragma mark - VRDebugView
@implementation VRDebugView

-(instancetype)initWithVRView:(VRView *)view{
    self = [super initWithFrame:view.bounds];
    if (self) {
        _view = view;
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.userInteractionEnabled = YES;
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 55, 0, 55, 55)];
    [close setTitle:@"✕" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:close];
    
    _eyeDiffSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 50, self.frame.size.width - 40, 40)];
    [_eyeDiffSlider addTarget:self action:@selector(didSlide:) forControlEvents:UIControlEventValueChanged];
    _eyeDiffSlider.minimumValue = 0;
    _eyeDiffSlider.maximumValue = 2;
    _eyeDiffSlider.value = _view.camera.cameraPositionDiff;
    [self addSubview:_eyeDiffSlider];
    
    _eyeDiffValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _eyeDiffSlider.frame.size.width, 20)];
    _eyeDiffValueLabel.textColor = [UIColor whiteColor];
    _eyeDiffValueLabel.textAlignment = NSTextAlignmentCenter;
    _eyeDiffValueLabel.text = [NSString stringWithFormat:@"%f",_view.camera.cameraPositionDiff];
    [self addSubview:_eyeDiffValueLabel];
    
    _shaderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50, 120, 50, 40)];
    [_shaderSwitch addTarget:self action:@selector(didSwitchShader:) forControlEvents:UIControlEventValueChanged];
    _shaderSwitch.on = _view.shaderType == t_vr_camera_shader_passthrough;
    [self addSubview:_shaderSwitch];
    
    _shaderValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 110, 20)];
    _shaderValueLabel.text = _view.shaderType == t_vr_camera_shader_pincushion_distortion ?  @"pincushion distortion" : @"passthrough";
    _shaderValueLabel.textColor = [UIColor whiteColor];
    _shaderValueLabel.font = [UIFont systemFontOfSize:10];
    _shaderValueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_shaderValueLabel];
    
    _orthograpicSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(135, 120, 50, 40)];
    [_orthograpicSwitch addTarget:self action:@selector(didSwitchOrthographic:) forControlEvents:UIControlEventValueChanged];
    _orthograpicSwitch.on = _view.camera.leftCameraNode.camera.usesOrthographicProjection;
    [self addSubview:_orthograpicSwitch];
    
    _orthograpicValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 90, 100, 20)];
    _orthograpicValueLabel.font = [UIFont systemFontOfSize:10];
    _orthograpicValueLabel.text = _view.camera.leftCameraNode.camera.usesOrthographicProjection ? @"orthographic" : @"normal";
    _orthograpicValueLabel.textColor = [UIColor whiteColor];
    _orthograpicValueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_orthograpicValueLabel];
    
}


-(void)didSlide:(UISlider *)slider{
    _eyeDiffValueLabel.text = [NSString stringWithFormat:@"%f",slider.value];
    if (_didUpdateEyeDiff) {
        _didUpdateEyeDiff(slider.value);
    }
}

-(void)didSwitchShader:(UISwitch *)switcher{
    
    if (switcher.on) {
        _shaderValueLabel.text = @"pincushion distortion";
    } else {
        _shaderValueLabel.text = @"passthrough";
    }
    
    if (_didUpdateShader) {
        _didUpdateShader(switcher.on);
    }
}
-(void)didSwitchOrthographic:(UISwitch *)switcher{
    if (switcher.on) {
        _orthograpicValueLabel.text = @"orthographic";
    } else {
        _orthograpicValueLabel.text = @"normal";
    }
    
    if (_didChangeCamera) {
        _didChangeCamera(switcher.on);
    }
}


-(void)close:(id)sender{
    if (_didClose) _didClose();
    [self removeFromSuperview];
}

@end