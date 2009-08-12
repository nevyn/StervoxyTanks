//
//  ExplosionEffect.m
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ExplosionEffect.h"


@implementation ExplosionEffect

-(id)initAt:(CGPoint)point_;
{
  if(![super initAt:point_]) return nil;
  
  textures = [[NSArray alloc] initWithObjects:[Texture2D textureNamed:@"explosion-1.png"],[Texture2D textureNamed:@"explosion-2.png"],[Texture2D textureNamed:@"explosion-3.png"],nil];
  currentTexture = [textures objectAtIndex:0];
  
  life = 0;
  return self;
}

-(BOOL)updateWithDelta:(float)dtime;
{
  life += dtime;
  if(life >= 0.07){
    life = 0;
    int i = [textures indexOfObject:currentTexture];
    i++;
    if(i == 3) 
      return NO;
    currentTexture = [textures objectAtIndex:i];
  }
  return YES;
}

-(void)draw;
{
  [currentTexture drawInRect:CGRectMake(point.x-0.1, point.y-0.1, 0.2, 0.2)];
}

@end
