//
//  Tank.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Tank.h"
#import "Game.h"

@implementation Tank

@synthesize controller;

-(id)init;
{
  if(![super init]) return nil;
  
  texture = [[Texture2D textureNamed:@"tank.png"] retain];
  
  float radius = 0.05;
  body  = [[CPBody alloc] initWithMass:10.0 momentForCircleWithRadius:radius innerRadius:0 offset:cpvzero];
  shape = [[CPCircleShape alloc] initWithBody:body radius:radius offset:cpvzero];
  shape.friction = 0.5;

  body.delegate = self;
  shape.data = self;
  
  
  return self;
}

-(void)dealloc;
{
  [shape release];
  [body release];
  [texture release];
  [super dealloc];
}

-(void)draw;
{
  
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

-(BOOL)didCollideWith:(CPShape *)s;
{
  [controller tank:self collidedWithShape:s];
  collidedLastFrame = YES;
  return YES;
}

-(void)integrateVelocityForBody:(CPBody*)b gravity:(cpVect)gravity damping:(cpFloat)damping delta:(cpFloat)dt;{
  [controller updateTank:self];
  
  body.angle = newAngle;
  body.velocity = newVelocity;
}

-(void)setHeading:(CGPoint)headingVector;
{
  float x = headingVector.x;
  float y = headingVector.y;
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
    newAngle  = tiltangle*180.0/M_PI;
  newVelocity = vel;
  //[body applyForce:f atOffset:cpvzero];
  
  //NSLog(@"angle: %.3f tilt: %.3f turn: %.3f", angle, tiltangle);  
}

-(void)shootAt:(CGPoint)point;
{
  CGPoint pFrom = CGPointMake(body.position.x, body.position.y);
  
  [[Game sharedGame].currentLevel createBulletAt:pFrom heading:point];
}


@end
