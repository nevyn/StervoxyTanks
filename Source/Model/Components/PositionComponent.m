//
//  PositionComponent.m
//  StervoxyTanks
//
//  Created by Per Borgman on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PositionComponent.h"


@implementation PositionComponent

@synthesize position; 

-(id)initWithDictionary:(NSDictionary*)props entityID:(uint64_t)eid_;
{
	if (![super initWithDictionary:props entityID:eid_]) return nil;
	
	
	NSMutableArray *pos = [props objectForKey:@"position"];
	position = [Vector2 vectorWithX:[[pos objectAtIndex:0] doubleValue]
								  y:[[pos objectAtIndex:1] doubleValue]];
	
	return self;
}


@end
