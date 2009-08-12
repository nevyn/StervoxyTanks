//
//  AITankController.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AITankController.h"
#import "Tank.h"
#import "Game.h"

float frand(){
  return (rand()%10000000) / 10000000.0;
}

@implementation AITankController

-(void)updateTank:(Tank*)tank;
{
  static float t = 0;
  static float nextShot = -1;
  
  nextShot -= 1/60.0;
  if(nextShot <= 0){
    nextShot = frand()*3;
    NSLog(@"next shot in %f", nextShot);
    CGPoint target = CGPointMake(frand()*2-1, frand()*2-1);
    [tank shootAt:target];
  }
  t += M_PI/50.0;
  
  headingVector = CGPointMake(1.2*cos(t), 1.2*sin(t));
  
  [tank setHeading:headingVector];
}


@end
