//
//  ViewController.m
//  vr-scene-kit-ios
//
//  Created by areschoug on 14/11/14.
//  Copyright (c) 2014 areschoug. All rights reserved.
//

#import "ViewController.h"

#import "VRView.h"
#import "VRMotionManager.h"

#import "VRView+Debug.h"

@interface ViewController ()

@property VRView *vrView;
@property VRMotionManager *motionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //create scene
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.dae"];
    
    //vr view
    _vrView = [[VRView alloc] initWithFrame:self.view.bounds];
    [_vrView setScene:scene];
    [self.view addSubview:_vrView];
    
#ifdef DEBUG
    [_vrView enableDebugMode];
#endif
    
    //motion manger
    _motionManager = [VRMotionManager motionManager];
    _motionManager.cameraNode = (SCNNode *)_vrView.camera;
    
    //ship
    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:NO];
    ship.position = SCNVector3Make(0, 0, -10);
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_motionManager start];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_motionManager stop];
}

@end
