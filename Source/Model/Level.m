//
//  Level.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Level.h"


@implementation Level

@synthesize tank, space;

-(id)init;
{
  if(![super init]) return nil;
  
  staticBody = [[CPBody alloc] initWithMass:INFINITY moment:INFINITY];
  space = [[CPSpace alloc] init];
  
  staticObjects = [[NSMutableArray alloc] init];
  
  tank = [[Tank alloc] initWithSpace:space];
  
  [self loadLevel:1];
  
  return self;
}

-(void)dealloc;
{
  [staticBody release];
  [staticObjects release];
  [space release];
  [super dealloc];
}

-(void)wallFrom:(cpVect)p1 to:(cpVect)p2;
{
  //create
  CPShape *wall = [[CPSegmentShape alloc] initWithBody:staticBody pointA:p1 pointB:p2 radius:0];
  //setup
  wall.friction = 1.0;
  //add to space
  [space addStaticShape:wall];
  //hold instance
  [staticObjects addObject:wall];
}

-(void)loadLevel:(int)levelNumber;
{
  float width = 1;
  float height = 1;
  //some walls
  [self wallFrom:cpv(-width, -height) to:cpv(-width, height)]; //left
  [self wallFrom:cpv(width, -height) to:cpv(width, height)]; //right
  [self wallFrom:cpv(-width, height) to:cpv(width, height)]; //top
  [self wallFrom:cpv(-width, -height) to:cpv(width, -height)]; //bottom
  
  NSLog(@"Level loaded");
}

-(void)update;
{
  [space stepWithDelta:0.4f];
}

-(void)draw;
{
  [tank draw];
}

@end
