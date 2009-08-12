//
//  Tank.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Tank.h"

#import "TCFakeAccelerometer.h"
//#ifdef TARGET_IPHONE_SIMULATOR
//#	define TankAccelerometer TCFakeAccelerometer
//#else
#	define TankAccelerometer UIAccelerometer
//#endif

@implementation Tank

-(id)init;
{
  if(![super init]) return nil;
  
  texture = [[Texture2D textureNamed:@"tank.png"] retain];
  
  float radius = 0.05;
  body  = [[CPBody alloc] initWithMass:10.0 momentForCircleWithRadius:radius innerRadius:0 offset:cpvzero];
  shape = [[CPCircleShape alloc] initWithBody:body radius:radius offset:cpvzero];
  shape.friction = 0.5;

  
  shape.data = self;
  
  hasAccelerometer = NO;
  
  [TankAccelerometer sharedAccelerometer].delegate = self;
  [TankAccelerometer sharedAccelerometer].updateInterval = 0.1;
  
  return self;
}

-(void)dealloc;
{
  [shape release];
  [body release];
  [texture release];
  [super dealloc];
}

-(void)handleAccelerometerChangeX:(float)x y:(float)y;
{
  
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
  
  float angle = body.angle*M_PI/180.0;
  //speed
  float speed = sqrt(x*x+y*y);
  speed = speed * 0.05;
  //velocity vector based on heading
  float sx = speed * cos(angle);
  float sy = speed * sin(angle);
  cpVect vel = cpv(sx, sy);
  
  //turning
  //angle iphone is tilted at
  float tiltangle = atan2f(y, x);
  //delta to turn the tank

  float turn = (tiltangle - angle);
  if(angle - tiltangle < turn) turn = angle-tiltangle;
//  body.angularVelocity = turn;
  if(y != 0 || x != 0)
    body.angle = tiltangle*180.0/M_PI;
  body.velocity = vel;
  //[body applyForce:f atOffset:cpvzero];
  
  //NSLog(@"angle: %.3f tilt: %.3f turn: %.3f", angle, tiltangle);
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
{
  float x = acceleration.x; //-left     +right
  float y = acceleration.y; //+forward  -backward
  //float z = acceleration.z; //+front    -back
	NSLog(@"%f %f", x, y);
  [self handleAccelerometerChangeX:x y:y];
  hasAccelerometer = YES;
}

-(void)draw;
{
  if(!hasAccelerometer)
    [self handleAccelerometerChangeX:0.3 y:0.2];
  
  glPushMatrix();
  
  glTranslatef(body.position.x, body.position.y, 0);
  glRotatef(body.angle-90, 0, 0, 1.0);
  glEnable(GL_TEXTURE_2D);
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  [texture drawInRect:CGRectMake(-0.05, -0.05, 0.1, 0.1)];
  
  glPopMatrix();
  
  NSString *t = [NSString stringWithFormat:@"%.2f %.2f", body.position.x, body.position.y];
  Texture2D *text = [[Texture2D alloc] initWithString:t dimensions:CGSizeMake(128,128) alignment:UITextAlignmentLeft fontName:@"Helvetica" fontSize:20];
  [text drawInRect:CGRectMake(-1, 0, 2, 1)];
  [text release];
  
 // NSLog(@"tank position: %.2f %.2f", body.position.x, body.position.y);
}

-(BOOL)didCollideWith:(CPShape *)shape;
{
  collidedLastFrame = YES;
  return YES;
}

@end
