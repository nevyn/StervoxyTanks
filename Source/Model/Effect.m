//
//  Effect.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Effect.h"


@implementation Effect

@synthesize delay;


-(id)initAt:(CGPoint)point_;
{
  if(![super init]) return nil;
  
  point = point_;
  return self;
}

-(BOOL)updateWithDelta:(float)dtime;
{
  return NO;
}

-(void)draw;
{
  
}

@end
