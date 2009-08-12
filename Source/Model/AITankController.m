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
#import "Level.h"
#import "cutils.h"

@implementation AITankController

-(void)updateTank:(Tank*)tank;
{
  static float t = 0;
  static float nextShot = 3.0;
  
  nextShot -= 1/60.0;
  if(nextShot <= 0){
    nextShot = frand()*3 + 1;
    NSLog(@"next shot in %f", nextShot);
    Tank *playerTank = [Game sharedGame].currentLevel.playerTank;
    CGPoint target = CGPointMake(playerTank.body.position.x, playerTank.body.position.y);
    [tank shootAt:target];
  }
  t += M_PI/50.0;
  
  headingVector = CGPointMake(1.2*cos(t), 1.2*sin(t));
  
  [tank setHeading:headingVector];
}


@end
