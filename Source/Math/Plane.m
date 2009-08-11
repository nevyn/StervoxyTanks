#import "Plane.h"

#import <math.h>
#import "Vector3.h"

@implementation Plane

@synthesize a;
@synthesize b;
@synthesize c;
@synthesize d;

- (id)init;
{
	return [self initWithA:1 b:0 c:0 d:0];
}

- (id)initWithA:(float)a_ b:(float)b_ c:(float)c_ d:(float)d_;
{
	NSParameterAssert(!(0 == a_ && 0 == b_ && 0 == c_));
	
	if (![super init]) return nil;
	
	a = a_;
	b = b_;
	c = c_;
	d = d_;
	
	return self;
}

- (id)initWithPlane:(Plane*)plane;
{
	return [self initWithA:plane->a b:plane->b c:plane->c d:plane->d];
}

+ (id)plane;
{
	return [[[[self class] alloc] init] autorelease];
}

+ (id)planeWithA:(float)a_ b:(float)b_ c:(float)c_ d:(float)d_;
{
	return [[[[self class] alloc] initWithA:a_ b:b_ c:c_ d:d_] autorelease];
}

+ (id)planeWithPlane:(Plane*)plane;
{
	return [[[[self class] alloc] initWithA:plane->a b:plane->b c:plane->c d:plane->d] autorelease];
}

- (id)copyWithZone:(NSZone*)zone;
{
	return [self retain];
}

- (id)mutableCopyWithZone:(NSZone*)zone;
{
	return [[MutablePlane alloc] initWithPlane:self];
}

/*- (BOOL)isEqual:(Plane*)plane;
{
}

- (NSComparisonResult)compare:(Plane*)plane;
{
}*/

- (float)element:(NSUInteger)element;
{
	NSParameterAssert(4 > element);
	return (&a)[element];
}

- (const float*)elements;
{
	return &a;
}

- (const float*)elementsPtr:(NSUInteger)element;
{
	NSParameterAssert(4 > element);
	return &(&a)[element];
}

- (id)normalizedPlane;
{
	float magnitude = sqrt(a * a + b * b + c * c);
	
	return [[self class] planeWithA:a / magnitude b:b / magnitude c:c / magnitude d:d / magnitude];
}

- (float)distanceToPoint:(Vector3*)point;
{
	return a * point.x + b * point.y + c * point.z + d;
}

- (NSString*)description;
{
	return [NSString stringWithFormat:@"(%.2f %.2f %.2f %.2f)", a, b, c, d];
}

@end

@implementation MutablePlane

@end
