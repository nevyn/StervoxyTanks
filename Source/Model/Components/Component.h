//
//  Component.h
//  StervoxyTanks
//
//  Created by Per Borgman on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Component : NSObject {
	
	uint64_t entityID;
		
}
@property (readonly) uint64_t entityID;

-(id)initWithDictionary:(NSDictionary*)props entityID:(uint64_t)eid_;
// Call these from subclasses!
+(NSArray*)components;
+(id)componentForEntityID:(uint64_t)eid;
@end
