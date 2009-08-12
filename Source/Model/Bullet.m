//
//  Bullet.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"
#import "Tank.h"
#import "Game.h"
#import "Level.h"

@interface NSObject (BulletDelegate)
-(void)bullet:(Bullet*)bullet hits:(CPShape *)shape exploading:(BOOL)exploading;
@end


@implementation Bullet

@synthesize bouncesLeft, popper;

-(id)init;
{
  if(![super init]) return nil;
  
  texture = [[Texture2D textureNamed:@"bullet.png"] retain];
  
  float radius = 0.05;
  body  = [[CPBody alloc] initWithMass:10.0 momentForCircleWithRadius:radius innerRadius:0 offset:cpvzero];
  shape = [[CPCircleShape alloc] initWithBody:body radius:radius offset:cpvzero];
  shape.friction = 0.5;
  shape.data = self;
  
  targetRect.size.height *= 2;
  
  //normal bullets bounce one time
  bouncesLeft = 1;
  
  canHitSelf = NO;
    
  return self;
}


-(void)destroyedTank:(Tank*)tank;
{
  [tank destroyedByBullet:self];
  [[Game sharedGame].currentLevel tank:tank wasDestroyedByBullet:self];
}


//The bullet collided with something
-(BOOL)didCollideWith:(CPShape*)otherShape;
{
  //Bullet hit a tank?
  if([otherShape.data isKindOfClass:Tank.class]) {
    //Was it the shooter?
    NSLog(@"%@ hit %@. popper is %@", self, otherShape.data, popper);
    if(otherShape.data == popper){
      //can bullet hit shooter? (will always collide on launch. kill shooter if bullet bounced
      if(canHitSelf){
        [self destroyedTank:popper];
        return NO;
      }
    } else {
      //kill tank
      [self destroyedTank:(Tank*)otherShape.data];
      return NO;
    }
  } else {
    NSLog(@"%@ hit something not a tank: %@", self, otherShape.data);
    if(bouncesLeft == 0){    
      //kill it
      if([delegate respondsToSelector:@selector(bullet:hits:exploading:)])
        [delegate bullet:self hits:otherShape exploading:YES];
      return NO;
    } else {
      //bounce
      canHitSelf = YES;
      bouncesLeft--;
      if([delegate respondsToSelector:@selector(bullet:hits:exploading:)])
        [delegate bullet:self hits:otherShape exploading:NO];
      return YES;
    }
  }
  return YES;
}

-(void)draw;
{
  //calc angle
  float angle = atan2(body.velocity.y, body.velocity.x);
  body.angle = angle*180/M_PI;
  [super draw];
}

@end
