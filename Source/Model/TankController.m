//
//  TankController.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TankController.h"

#import "Tank.h"

@implementation TankController

-(id)init;
{
  if(![super init]) return nil;

  return self;
}

-(void)updateTank:(Tank*)tank;
{
  [tank setHeading:headingVector];
}

-(void)tank:(Tank*)tank collidedWithShape:(CPShape *)shape;
{
  
}

@end
