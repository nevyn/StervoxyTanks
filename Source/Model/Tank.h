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

@interface Tank : NSObject <UIAccelerometerDelegate> {
  Texture2D *texture;
  CPBody *body;
  CPShape *shape;
  
  BOOL hasAccelerometer;
}

-(id)initWithSpace:(CPSpace*)space;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

-(void)draw;

@end
