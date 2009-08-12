//
//  Factory.m
//  StervoxyTanks
//
//  Created by Per Borgman on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Factory.h"
#import "SBJsonParser.h"

static uint64_t id_incr = 0;

@implementation Factory

+ (int)entityFromArchetype:(NSString *)name;
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
	int this_id = ++id_incr;
	
	NSString *jsonPath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
	NSString *json = [NSString stringWithContentsOfFile:jsonPath];
	if(!json) {
		NSLog(@"-[Factory entityNamed:]: No such archetype: %@", name);
		return this_id;
	}
	
	NSMutableArray *archetype = [[[SBJsonParser new] autorelease] objectWithString:json];
	
	for(id componentInfo in archetype) {
		NSString *componentName = [componentInfo objectForKey:@"type"];
		Class componentClass = NSClassFromString(componentName);
		if(componentClass == nil) {
			NSLog(@"Couldn't create component %@ for %ld", componentName, this_id);
			continue;
		}
		
		[[componentClass alloc] initWithDictionary:[componentInfo objectForKey:@"data"]
																														 entityID:this_id];
	}
	return this_id;
}

@end
