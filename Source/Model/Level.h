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
#import "Bullet.h"


@interface Level : NSObject<PhysicalObjectDelegate, BulletDelegate> {
  
  NSMutableArray *staticObjects;
  CPBody *staticBody;
  
  CPSpace *space;
  
  NSMutableArray *tanks;
  Tank *playerTank;
  
  NSMutableArray *bullets;
  
  BOOL somethingCollided;
  
  NSMutableArray *effects;
  
}

@property (readonly, nonatomic) Tank *playerTank;
@property (readonly, nonatomic) CPSpace *space;

-(void)wallFrom:(cpVect)p1 to:(cpVect)p2;

-(void)update;
-(void)draw;

-(void)loadLevel:(int)levelNumber;

-(void)createBulletAt:(CGPoint)pFrom heading:(CGPoint)pTo;

//Delegate stuff
-(BOOL)shapesDidCollide:(CPShape*)shape1 with:(CPShape*)shape2 contacts:(NSArray*)contacts normalCoefficient:(cpFloat)normal_coef;
-(void)bullet:(Bullet*)bullet hits:(CPShape*)otherShape exploading:(BOOL)exploads;

@end
