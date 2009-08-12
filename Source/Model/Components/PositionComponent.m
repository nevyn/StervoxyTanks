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

- (id)initFromDictionary:(NSDictionary *)component;
{
	if (![super init]) return nil;
	
	//rawJson = @"{ \"position\" : [ 2.4, 1.99 ] }";
	
	//id component = [[[SBJsonParser new] autorelease] objectWithString:rawJson];
		
	NSMutableArray *pos = [component objectForKey:@"position"];
	position = [Vector2 vectorWithX:[[pos objectAtIndex:0] doubleValue]
								  y:[[pos objectAtIndex:1] doubleValue]];
	
	return self;
}


@end
