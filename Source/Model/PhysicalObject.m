//
//  PhysicalObject.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhysicalObject.h"


@implementation PhysicalObject

@synthesize shape, body, texture;

-(id)init;
{
  if(![super init]) return nil;
  
  targetRect = CGRectMake(-0.05, -0.05, 0.1, 0.1);
  
  return self;
}

-(void)draw;
{
  glPushMatrix();
  
  //default translation, rotation and blitting
  glTranslatef(body.position.x, body.position.y, 0);
  glRotatef(body.angle-90, 0, 0, 1.0);
  [texture drawInRect:targetRect];
  
  glPopMatrix();
}

-(BOOL)didCollideWith:(CPShape *)otherShape;
{
  return YES;
}

-(void)addToSpace:(CPSpace*)space;
{
  [space addBody:body];
  [space addShape:shape];
}

-(void)removeFromSpace:(CPSpace*)space;
{
  [space removeBody:body];
  [space removeShape:shape];
}

@end
