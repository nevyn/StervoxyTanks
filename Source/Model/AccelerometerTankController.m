//
//  AccelerometerTankController.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TankController.h"


#import "TCFakeAccelerometer.h"
#if TARGET_IPHONE_SIMULATOR
#	define TankAccelerometer TCFakeAccelerometer
#else
#	define TankAccelerometer UIAccelerometer
#endif

#import "Tank.h"

@implementation AccelerometerTankController

-(id)init;
{
  if(![super init]) return nil;
  
  [TankAccelerometer sharedAccelerometer].delegate = self;
  [TankAccelerometer sharedAccelerometer].updateInterval = 0.1;
  
  return self;
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
{
  float x = acceleration.x; //-left     +right
  float y = acceleration.y; //+forward  -backward
  //float z = acceleration.z; //+front    -back
	//NSLog(@"%f %f", x, y);
  
  if(fabsf(x) > 0.1){ //deadzone
    x = x/2.0; //0 - +-0.5
  } else {
    x = 0;
  }
  if(fabsf(y) > 0.1){
    y = y/2.0;
  } else {
    y = 0;
  }
  
  headingVector = CGPointMake(x, y);
}

-(void)updateTank:(Tank*)tank;
{
  [tank setHeading:headingVector];
}

-(void)tank:(Tank*)tank collidedWithShape:(CPShape *)shape;
{
  
}

@end
