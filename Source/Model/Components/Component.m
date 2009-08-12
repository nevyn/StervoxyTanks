//
//  Component.m
//  StervoxyTanks
//
//  Created by Per Borgman on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

static NSMutableDictionary *__components = nil;
static NSMutableDictionary *components() {
	if(!__components)
		__components = [[NSMutableDictionary alloc] init];
	return __components;
}
static NSMutableArray *componentsIn(Class klass) {
	NSMutableArray *componentsIn_ = [components() objectForKey:NSStringFromClass(klass)];
	if(!componentsIn_) {
		componentsIn_ = [[NSMutableArray alloc] init];
		[components() setObject:componentsIn_ forKey:NSStringFromClass(klass)];
	}
	return componentsIn_;
}

@implementation Component
@synthesize entityID;
-(id)initWithDictionary:(NSDictionary*)props entityID:(uint64_t)eid_;
{
	if( ![super init] ) return nil;
	
	entityID = eid_;
	
	[componentsIn([self class]) addObject:self];
	
	return self;
}
-(void)dealloc;
{
	[componentsIn([self class]) removeObject:self];
	[super dealloc];
}
+(NSArray*)components;
{
	return [[componentsIn([self class]) copy] autorelease];
}
+(id)componentForEntityID:(uint64_t)eid;
{
	for(Component *component in [[self class] components]) {
		if(component.entityID == eid)
			return component;
	}
	return nil;
}

@end
