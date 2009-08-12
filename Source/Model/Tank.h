//
//  Tank.h
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"
#import "CPChipmunk.h"
#import "PhysicalObject.h"
#import "TankController.h"

@interface Tank : PhysicalObject <UIAccelerometerDelegate, CPBodyDelegate> {
  
  BOOL collidedLastFrame;
  
  cpVect newVelocity;
  float newAngle;
  
  id<TankController> controller;
}

@property (nonatomic, retain) id<TankController> controller;


-(void)draw;


-(void)integrateVelocityForBody:(CPBody*)b gravity:(cpVect)gravity damping:(cpFloat)damping delta:(cpFloat)dt;
//heading and speed (length of vector)
-(void)setHeading:(CGPoint)headingVector;

-(void)shootAt:(CGPoint)point;

@end
