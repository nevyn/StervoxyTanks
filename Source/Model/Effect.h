//
//  Effect.h
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Effect : NSObject {
  CGPoint point;
  float delay;
}

@property (nonatomic) float delay;

-(id)initAt:(CGPoint)point;


//return NO when effect wants to be removed
-(BOOL)updateWithDelta:(float)dtime;
-(void)draw;

@end
