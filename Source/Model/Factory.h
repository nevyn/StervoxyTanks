//
//  Factory.h
//  StervoxyTanks
//
//  Created by Per Borgman on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Component.h"

@interface Factory : NSObject {

}

+ (int)entityFromArchetype:(NSString *)name;

@end
