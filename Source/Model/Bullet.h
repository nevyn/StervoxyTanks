//
//  Bullet.h
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CPChipmunk.h"
#import "Texture2D.h"
#import "PhysicalObject.h"

@class Tank;

@interface Bullet : PhysicalObject {
  float life;
  int bouncesLeft;
  BOOL canHitSelf; //YES after first bounce
  Tank *popper; //the tank that fired the bullet
}

@property (readonly, nonatomic) int bouncesLeft;
@property (nonatomic, retain) Tank *popper;

-(void)destroyedTank:(Tank*)tank;

@end

@protocol BulletDelegate
-(void)bullet:(Bullet*)bullet hits:(CPShape*)shape exploading:(BOOL)exploads;
@end

