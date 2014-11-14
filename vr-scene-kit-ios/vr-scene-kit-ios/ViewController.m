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
    _vrView.backgroundColor = [UIColor blackColor];
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
    ship.position = SCNVector3Make(0, 10, 0);
    [ship runAction:[SCNAction rotateToX:M_PI/2 y:0 z:0 duration:3]];
    
    //sphere
    SCNNode *sphereNode = [SCNNode node];
    SCNSphere *sphere = [SCNSphere sphereWithRadius:0.2];
    sphere.firstMaterial.diffuse.contents = [UIColor redColor];
    [sphereNode addChildNode:[SCNNode nodeWithGeometry:sphere]];
    sphereNode.position = SCNVector3Make(5, 0, 0);
    [scene.rootNode addChildNode:sphereNode];
    
    //cone
    SCNNode *coneNode = [SCNNode node];
    SCNCone *cone = [SCNCone coneWithTopRadius:0 bottomRadius:1 height:0.4];
    cone.firstMaterial.diffuse.contents = [UIColor greenColor];
    [coneNode addChildNode:[SCNNode nodeWithGeometry:cone]];
    coneNode.position = SCNVector3Make(-5, 0, 0);
    [scene.rootNode addChildNode:coneNode];
    
    //globe node
    
    SCNNode *globeNode = [SCNNode node];
    SCNSphere *globe = [SCNSphere sphereWithRadius:30];
    globe.firstMaterial.diffuse.contents = [UIImage imageNamed:@"earth_diffuse.jpg"];
    globe.firstMaterial.specular.contents = [UIImage imageNamed:@"earth_specular.jpg"];
    globe.firstMaterial.ambient.contents = [UIImage imageNamed:@"earth_ambient.jpg"];
    globe.firstMaterial.normal.contents = [UIImage imageNamed:@"earth_normal.jpg"];
    globe.firstMaterial.doubleSided = YES;
    [globeNode addChildNode:[SCNNode nodeWithGeometry:globe]];
//    [scene.rootNode addChildNode:globeNode];
    
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
