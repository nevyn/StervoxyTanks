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

@interface Bullet : PhysicalObject {

  int bouncesLeft;
}
@property (readonly, nonatomic) int bouncesLeft;


@end
