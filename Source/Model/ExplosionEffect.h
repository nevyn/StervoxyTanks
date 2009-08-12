//
//  ExplosionEffect.h
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Effect.h"
#import "Texture2D.h"

@interface ExplosionEffect : Effect {
  NSArray *textures;
  Texture2D *currentTexture;
  float life;
}

@end
