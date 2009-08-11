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

@interface Tank : PhysicalObject <UIAccelerometerDelegate> {
  
  BOOL hasAccelerometer;
  BOOL collidedLastFrame;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

-(void)draw;


@end
