//
//  PhysicalObject.h
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CPChipmunk.h"
#import "Texture2D.h"

@class PhysicalObject;


@interface PhysicalObject : NSObject {
  Texture2D *texture;
  CPBody *body;
  CPShape *shape;  
  CGRect targetRect;
  id delegate;
}

@property (nonatomic, readonly) CPShape *shape;
@property (nonatomic, readonly) CPBody *body;
@property (nonatomic, retain) Texture2D *texture;
@property (nonatomic, assign) id delegate;

-(id)init;

-(void)addToSpace:(CPSpace*)space;
-(void)removeFromSpace:(CPSpace*)space;

-(BOOL)didCollideWith:(CPShape *)otherShape;

-(void)draw;

@end
