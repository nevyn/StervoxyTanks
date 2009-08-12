//
//  PhysicsComponent.h
//  StervoxyTanks
//
//  Created by Per Borgman on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "CPChipmunk.h"

@interface PhysicsComponent : Component {
	CPBody *body;
	CPShape *shape;
}

@property (nonatomic, readonly) CPShape *shape;
@property (nonatomic, readonly) CPBody *body;

@end
