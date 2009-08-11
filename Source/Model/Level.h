//
//  Level.h
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CPChipmunk.h"
#import "Tank.h"

@interface Level : NSObject {
  
  NSMutableArray *staticObjects;
  CPBody *staticBody;
  
  CPSpace *space;
  
  Tank *tank;
}

@property (readonly, nonatomic) Tank *tank;
@property (readonly, nonatomic) CPSpace *space;

-(void)wallFrom:(cpVect)p1 to:(cpVect)p2;

-(void)update;
-(void)draw;

-(void)loadLevel:(int)levelNumber;

@end
