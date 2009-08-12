//
//  Game.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Game.h"


@implementation Game

@synthesize currentLevel;


static Game *sharedGame = nil;

+ (Game*)sharedGame
{
  @synchronized(self) {
    if (sharedGame == nil) {
      [[self alloc] init]; // assignment not done here
    }
  }
  return sharedGame;
}

+ (id)allocWithZone:(NSZone *)zone
{
  @synchronized(self) {
    if (sharedGame == nil) {
      sharedGame = [super allocWithZone:zone];
      return sharedGame;  // assignment and return on first allocation
    }
  }
  return nil; //on subsequent allocation attempts return nil
}

@end
