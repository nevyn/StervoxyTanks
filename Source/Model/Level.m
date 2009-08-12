//
//  Level.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Level.h"

#import "Bullet.h"
#import "Box.h"
#import "Effect.h"
#import "ExplosionEffect.h"
#import "AITankController.h"
#import "TankController.h"
#import "cutils.h"

@implementation Level

@synthesize playerTank, space;

-(id)init;
{
  if(![super init]) return nil;
  
  staticBody = [[CPBody alloc] initWithMass:INFINITY moment:INFINITY];
  space = [[CPSpace alloc] init];
  space.delegate = self;
  
  staticObjects = [[NSMutableArray alloc] init];
  
  bullets = [[NSMutableArray alloc] init];
  
  effects = [[NSMutableArray alloc] init];
  
  tanks = [[NSMutableArray alloc] init];
    
  [self loadLevel:1];

  
  return self;
}

-(void)dealloc;
{
  for(Tank *tank in tanks)
    [tank removeFromSpace:space];
  [tanks release];
  
  [staticBody release];
  [staticObjects release];
  [space release];
  [effects release];
  [super dealloc];
}

-(void)wallFrom:(cpVect)p1 to:(cpVect)p2;
{
  //create
  CPShape *wall = [[CPSegmentShape alloc] initWithBody:staticBody pointA:p1 pointB:p2 radius:0];
  //setup
  wall.friction = 1.0;
  wall.elasticity = 1.0;
  //add to space
  [space addStaticShape:wall];
  //hold instance
  [staticObjects addObject:wall];
}

-(void)loadLevel:(int)levelNumber;
{
  float width = 1;
  float height = 1.5;
  //some walls
  [self wallFrom:cpv(-width, -height) to:cpv(-width, height)]; //left
  [self wallFrom:cpv(width, -height) to:cpv(width, height)]; //right
  [self wallFrom:cpv(-width, height) to:cpv(width, height)]; //top
  [self wallFrom:cpv(-width, -height) to:cpv(width, -height)]; //bottom
  
  
  Box *box = [[Box alloc] initWithRect:CGRectMake(-0.5, -0.5, 0.2, 0.2)];
  [box addToSpace:space];
  [bullets addObject:box];
  [box release];

  //player tank
  playerTank = [[Tank alloc] init];
  [playerTank addToSpace:space];
  playerTank.controller = [[[AccelerometerTankController alloc] init] autorelease];
  [tanks addObject:playerTank];
  
  //enemy tank
  Tank *tank = [[Tank alloc] init];
  [tank addToSpace:space];
  tank.controller = [[[AITankController alloc] init] autorelease];
  [tanks addObject:tank];
  
  NSLog(@"Level loaded");
}

-(void)update;
{
  [space stepWithDelta:0.4f];
  for(Effect *effect in [effects copy]){
    if(! [effect updateWithDelta:1/60.0]){
      [effects removeObject:effect];
    }
  }
}

-(void)draw;
{
  if(somethingCollided){
    glClearColor(1.0f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    somethingCollided = NO;
  } else {
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT); 
  }
  for(Tank *tank in tanks)
    [tank draw];
  for(PhysicalObject *obj in bullets){
    [obj draw];
  }
  
  for(Effect *effect in effects)
    [effect draw];
}

-(Bullet*)createBulletAt:(CGPoint)pFrom heading:(CGPoint)pTo;
{
  float angle = atan2(pTo.y-pFrom.y, pTo.x-pFrom.y);
  
  Bullet *bullet = [[Bullet alloc] init];
  bullet.body.position = cpv(pFrom.x, pFrom.y);
  bullet.body.angle = angle;
  float speed = 0.1;
  bullet.body.velocity = cpv(speed * cos(angle), speed * sin(angle));
  bullet.shape.elasticity = 1.0;
  bullet.delegate = self;
  
  [bullet addToSpace:space];
  [bullets addObject:bullet];
  return bullet;
}

//The collision delegate method
-(BOOL)shapesDidCollide:(CPShape*)shape1 with:(CPShape*)shape2 contacts:(NSArray*)contacts normalCoefficient:(cpFloat)normal_coef;
{
  if([shape1.data isKindOfClass:Bullet.class] && [shape2.data isKindOfClass:Bullet.class]){
    [self removeBullet:(Bullet*)shape1.data spawnEffect:1];
    [self removeBullet:(Bullet*)shape2.data spawnEffect:1];
  }
  
  if([shape1.data isKindOfClass:PhysicalObject.class])
    if(! [((PhysicalObject*)shape1.data) didCollideWith:shape2]) return NO;
  if([shape2.data isKindOfClass:PhysicalObject.class])
    if(! [((PhysicalObject*)shape2.data) didCollideWith:shape1]) return NO;
  
  somethingCollided = YES;
  //yes, handle collision please
  return YES;
}

-(void)bullet:(Bullet*)bullet hits:(CPShape*)otherShape exploading:(BOOL)exploads;
{
  if(exploads)
    [self removeBullet:bullet spawnEffect:1];
}

-(void)tank:(Tank*)tank wasDestroyedByBullet:(Bullet*)bullet;
{
  NSLog(@"%@ was destroyed by %@", tank, bullet);
  [self removeBullet:bullet spawnEffect:2];
  
  [tank removeFromSpace:space];
  [tanks removeObject:tank];
}

-(ExplosionEffect*)createExplosionAt:(CGPoint)point;
{
  ExplosionEffect *fx = [[ExplosionEffect alloc] initAt:point];
  [effects addObject:fx];
  [fx release];
  return fx;
}

-(void)createBigExplosionAt:(CGPoint)p;
{
  float spread = 0.1;
  __block float d = 0;
  float (^delay)() = ^{
    return d+=frand()*0.4;
  };
  Effect *e;
  e = [self createExplosionAt:CGPointMake(p.x, p.y)];
  e.delay = delay();
  
  e = [self createExplosionAt:CGPointMake(p.x+frand()*spread, p.y+frand()*spread)];
  e.delay = delay();

  e = [self createExplosionAt:CGPointMake(p.x+frand()*spread, p.y+frand()*spread)];
  e.delay = delay();
  
  e = [self createExplosionAt:CGPointMake(p.x+frand()*spread, p.y+frand()*spread)];
  e.delay = delay();
}

-(void)removeBullet:(Bullet*)bullet spawnEffect:(int)spawnEffect;
{
  if(spawnEffect){
    [bullet removeFromSpace:space];
    [bullets removeObject:bullet];
    cpVect p = bullet.body.position;
    if(spawnEffect == 1)
      [self createExplosionAt:CGPointMake(p.x, p.y)];
    if(spawnEffect == 2)
      [self createBigExplosionAt:CGPointMake(p.x, p.y)];
  }  
}


@end
