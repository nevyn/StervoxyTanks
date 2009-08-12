//
//  TankController.h
//  StervoxyTanks
//
//  Created by Patrik Sjöberg on 2009-08-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tank;
@class CPShape;

#pragma mark Protocol

@protocol TankController
-(void)updateTank:(Tank*)tank;
-(void)tank:(Tank*)tank collidedWithShape:(CPShape *)shape;
@end


#pragma mark Basic superclass
@interface TankController : NSObject<TankController, UIAccelerometerDelegate> {
  CGPoint headingVector;
}

-(void)updateTank:(Tank*)tank;
-(void)tank:(Tank*)tank collidedWithShape:(CPShape *)shape;

@end



#pragma mark Accelerometer
@interface AccelerometerTankController : TankController<UIAccelerometerDelegate> {
}
@end


