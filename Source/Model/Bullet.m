//
//  Bullet.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"
#import "Tank.h"

@implementation Bullet

@synthesize bouncesLeft;

-(id)init;
{
  if(![super init]) return nil;
  
  texture = [[Texture2D textureNamed:@"bullet.png"] retain];
  
  float radius = 0.05;
  body  = [[CPBody alloc] initWithMass:10.0 momentForCircleWithRadius:radius innerRadius:0 offset:cpvzero];
  shape = [[CPCircleShape alloc] initWithBody:body radius:radius offset:cpvzero];
  shape.friction = 0.5;
  shape.data = self;
  
  //normal bullets bounce one time
  bouncesLeft = 1;
    
  return self;
}


-(BOOL)didCollideWith:(CPShape*)otherShape;
{
  if([otherShape.data isKindOfClass:Tank.class]) return YES;
  if(bouncesLeft > 0){
    //bounce
    bouncesLeft--;
    return YES;
  } else {
    //kill it
    NSLog(@"KILL THE BULLET!");
    return NO;
  }
}

@end
