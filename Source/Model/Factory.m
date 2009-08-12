//
//  Factory.m
//  StervoxyTanks
//
//  Created by Per Borgman on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Factory.h"
#import "SBJsonParser.h"

@implementation Factory

- (int)entityNamed:(NSString *)name;
{
	// Öppna filen
	
	/*
	 
	 Format:
	 
		[
			{
				"type" : "PositionComponent",
				"data" : {
					[denna dict skickas till komponent-init]
				}
			},
			{
				"type" : "AssSmellComponent",
				"data" : {
					...
				}
			}
		]
	 
	 
	*/
	
	NSString *json = @"[ { \"type\" : \"PositionComponent\", \"data\" : { \"position\" : [ 2.4, 1.99 ] } } ]";
	
	NSMutableArray *archetype = [[[SBJsonParser new] autorelease] objectWithString:json];
	
	for(id componentInfo in archetype) {
		Class componentClass = NSClassFromString([componentInfo objectForKey:@"type"]);
		if(componentClass == nil) continue;
		
		[[componentClass alloc] initFromDictionary:[componentInfo objectForKey:@"data"]];
	}
}

@end
