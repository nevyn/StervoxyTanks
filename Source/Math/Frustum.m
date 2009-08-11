#import "Frustum.h"

#import "Matrix.h"
#import "Plane.h"
#import "Vector3.h"

@implementation Frustum

@synthesize nearPlane;
@synthesize farPlane;
@synthesize leftPlane;
@synthesize rightPlane;
@synthesize topPlane;
@synthesize bottomPlane;

- (id)initWithNearPlane:(Plane*)near farPlane:(Plane*)far leftPlane:(Plane*)left rightPlane:(Plane*)right topPlane:(Plane*)top bottomPlane:(Plane*)bottom;
{
	if (![super init]) return nil;
	
	nearPlane = [near copy];
	farPlane = [far copy];
	leftPlane = [left copy];
	rightPlane = [right copy];
	topPlane = [top copy];
	bottomPlane = [bottom copy];
	
	return self;
}

- (id)initWithViewProjection:(Matrix4*)viewProjection andNormalizePlanes:(BOOL)normalizeFlag;
{
	Plane *near	  = [Plane planeWithA:viewProjection.m41 + viewProjection.m31
									b:viewProjection.m42 + viewProjection.m32
									c:viewProjection.m43 + viewProjection.m33
									d:viewProjection.m44 + viewProjection.m34];
	
	Plane *far	  = [Plane planeWithA:viewProjection.m41 - viewProjection.m31
								    b:viewProjection.m42 - viewProjection.m32
								    c:viewProjection.m43 - viewProjection.m33
								    d:viewProjection.m44 - viewProjection.m34];
	
	Plane *left	  = [Plane planeWithA:viewProjection.m41 + viewProjection.m11
									b:viewProjection.m42 + viewProjection.m12
									c:viewProjection.m43 + viewProjection.m13
								    d:viewProjection.m44 + viewProjection.m14];
	
	Plane *right  = [Plane planeWithA:viewProjection.m41 - viewProjection.m11
									b:viewProjection.m42 - viewProjection.m12
									c:viewProjection.m43 - viewProjection.m13
								    d:viewProjection.m44 - viewProjection.m14];
	
	Plane *top	  = [Plane planeWithA:viewProjection.m41 - viewProjection.m21
									b:viewProjection.m42 - viewProjection.m22
									c:viewProjection.m43 - viewProjection.m23
									d:viewProjection.m44 - viewProjection.m24];
	
	Plane *bottom = [Plane planeWithA:viewProjection.m41 + viewProjection.m21
									b:viewProjection.m42 + viewProjection.m22
									c:viewProjection.m43 + viewProjection.m23
									d:viewProjection.m44 + viewProjection.m24];
	
	if (normalizeFlag)
	{
		near = [near normalizedPlane];
		far = [far normalizedPlane];
		left = [left normalizedPlane];
		right = [right normalizedPlane];
		top = [top normalizedPlane];
		bottom = [bottom normalizedPlane];
	}
	
	return [self initWithNearPlane:near farPlane:far leftPlane:left rightPlane:right topPlane:top bottomPlane:bottom];
}

- (void)dealloc;
{
	[bottomPlane release];
	[topPlane release];
	[rightPlane release];
	[leftPlane release];
	[farPlane release];
	[nearPlane release];
	
	[super dealloc];
}

+ (id)frustumWithNearPlane:(Plane*)near farPlane:(Plane*)far leftPlane:(Plane*)left rightPlane:(Plane*)right topPlane:(Plane*)top bottomPlane:(Plane*)bottom;
{
	return [[[[self class] alloc] initWithNearPlane:near farPlane:far leftPlane:left rightPlane:right topPlane:top bottomPlane:bottom] autorelease];
}

+ (id)frustumWithViewProjection:(Matrix4*)viewProjection andNormalizePlanes:(BOOL)normalizeFlag;
{
	return [[[[self class] alloc] initWithViewProjection:viewProjection andNormalizePlanes:normalizeFlag] autorelease];
}

- (BOOL)containsPoint:(Vector3*)point;
{
	if (0 <= [nearPlane distanceToPoint:point] && 0 <= [farPlane    distanceToPoint:point] &&
		0 <= [leftPlane distanceToPoint:point] && 0 <= [rightPlane  distanceToPoint:point] &&
		0 <= [topPlane  distanceToPoint:point] && 0 <= [bottomPlane distanceToPoint:point])
		return TRUE;
	
	return FALSE;
}

- (NSString*)description;
{
	return [NSString stringWithFormat:@"Near:%@ Far:%@ Left:%@ Right:%@ Top:%@ Bottom:%@", nearPlane, farPlane, leftPlane, rightPlane, topPlane, bottomPlane];
}

@end
