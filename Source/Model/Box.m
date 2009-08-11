//
//  Box.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Box.h"


@implementation Box

-(id)initWithRect:(CGRect)rect;
{
  if(![super init]) return nil;
  
  body = [[CPBody alloc] initWithMass:INFINITY moment:INFINITY];
  
  float x = rect.origin.x;
  float y = rect.origin.y;
  float w = rect.size.width/2.0;
  float h = rect.size.height/2.0;
  cpVect verts[] = {
		cpv(x+-w,y+-h),
		cpv(x+-w,y+ h),
		cpv(x+ w,y+ h),
		cpv(x+ w,y+-h),
	};
  shape = [[CPPolyShape alloc] initWithBody:body vertexCount:4 vertexes:verts offset:cpvzero];
  
  shape.friction = 0.5;
  shape.elasticity = 1.0;
  texture = [[Texture2D textureNamed:@"wall.png"] retain];
  
  targetRect = rect;
  
  return self;
}

-(void)draw;
{
  [texture drawInRect:targetRect];
}

-(void)addToSpace:(CPSpace*)space;
{
  [space addShape:shape];
}



@end
