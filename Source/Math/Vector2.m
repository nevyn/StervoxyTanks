#import "Vector2.h"

#import <math.h>
#import <memory.h>

Vec2 makeVec2(float x, float y)
{
	Vec2 v;
	v.x = x;
	v.y = y;
	
	return v;
}

static Vector2 *zero;
static Vector2 *xAxis;
static Vector2 *yAxis;
static Vector2 *negativeXAxis;
static Vector2 *negativeYAxis;

#define X v[0]
#define Y v[1]

@implementation Vector2

- (float)x;
{
	return X;
}

- (float)y;
{
	return Y;
}

+ (void)initialize;
{
	zero = [[Vector2 alloc] init];
	xAxis = [[Vector2 alloc] initWithX:1 y:0];
	yAxis = [[Vector2 alloc] initWithX:0 y:1];
	negativeXAxis = [[Vector2 alloc] initWithX:-1 y:0];
	negativeYAxis = [[Vector2 alloc] initWithX:0 y:-1];
}

+ (Vector2*)zero;
{
	return zero;
}

+ (Vector2*)xAxis;
{
	return xAxis;
}

+ (Vector2*)yAxis;
{
	return yAxis;
}

+ (Vector2*)negativeXAxis;
{
	return negativeXAxis;
}

+ (Vector2*)negativeYAxis;
{
	return negativeYAxis;
}

- (id)init;
{
	return [self initWithX:0 y:0];
}

- (id)initWithX:(float)x y:(float)y;
{
	float *vals = malloc(sizeof (float) * 2);
	vals[0] = x;
	vals[1] = y;
	
	if (![self initWithMemory:vals memoryResponsibility:Vector2MemoryResponsibilityFree])
	{
		free(vals);
		return nil;
	}
	
	return self;
}

- (id)initWithMemory:(float*)vals memoryResponsibility:(Vector2MemoryResponsibility)responsibility_;
{
	responsibility = responsibility_;
	
	if (responsibility == Vector2MemoryResponsibilityCopy)
		return [self initWithX:vals[0] y:vals[1]];
	
	v = vals;
	
	return self;
}

- (id)initWithVector2:(Vector2*)vector;
{
	return [self initWithX:vector->X y:vector->Y];
}

- (id)initWithVec2:(Vec2)vec;
{
	return [self initWithX:vec.x y:vec.y];
}

- (id)initWithScalar:(float)scalar;
{
	return [self initWithX:scalar y:scalar];
}

- (void)dealloc;
{
	if (responsibility == Vector2MemoryResponsibilityFree)
		free(v);
	
	[super dealloc];
}

+ (id)vector;
{
	return [[[[self class] alloc] init] autorelease];
}

+ (id)vectorWithX:(float)x y:(float)y;
{
	return [[[[self class] alloc] initWithX:x y:y] autorelease];
}

+ (id)vectorWithMemory:(float*)vals memoryResponsibility:(Vector2MemoryResponsibility)responsibility_;
{
	return [[[[self class] alloc] initWithMemory:vals memoryResponsibility:responsibility_] autorelease];
}

+ (id)vectorWithVector2:(Vector2*)vector;
{
	return [[[[self class] alloc] initWithVector2:vector] autorelease];
}

+ (id)vectorWithVec2:(Vec2)vec;
{
	return [[[[self class] alloc] initWithVec2:vec] autorelease];
}

+ (id)vectorWithScalar:(float)scalar;
{
	return [[[[self class] alloc] initWithScalar:scalar] autorelease];
}

- (id)copyWithZone:(NSZone*)zone;
{
	return [self retain];
}

- (id)mutableCopyWithZone:(NSZone*)zone;
{
	return [[MutableVector2 alloc] initWithVector2:self];
}

- (BOOL)isEqual:(Vector2*)vector;
{
	return X == vector->X && Y == vector->Y;
}

- (NSComparisonResult)compare:(Vector2*)vector;
{
	float l = [self squaredLength];
	float r = [vector squaredLength];
	
	if (l < r)
		return NSOrderedAscending;
	else if (l > r)
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

- (float)coord:(NSUInteger)coord;
{
	NSAssert(2 > coord, @"Illegal coordinate");
	return *(v + coord);
}

- (const float*)coordsPtr;
{
	return v;
}

- (const float*)coordsPtr:(NSUInteger)coord;
{
	NSAssert(2 > coord, @"Illegal coordinate");
	return (v + coord);
}

- (id)vectorByAddingVector:(Vector2*)rhs;
{
	return [[self class] vectorWithX:X + rhs->X y:Y + rhs->Y];
}

- (id)vectorByAddingScalar:(float)rhs;
{
	return [[self class] vectorWithX:X + rhs y:Y + rhs];
}

- (id)vectorBySubtractingVector:(Vector2*)rhs;
{
	return [[self class] vectorWithX:X - rhs->X y:Y - rhs->Y];
}

- (id)vectorBySubtractingScalar:(float)rhs;
{
	return [[self class] vectorWithX:X - rhs y:Y - rhs];
}

- (id)vectorByMultiplyingWithVector:(Vector2*)rhs;
{
	return [[self class] vectorWithX:X * rhs->X y:Y * rhs->Y];
}

- (id)vectorByMultiplyingWithScalar:(float)rhs;
{
	return [[self class] vectorWithX:X * rhs y:Y * rhs];
}

- (id)vectorByDividingWithVector:(Vector2*)rhs;
{
	return [[self class] vectorWithX:X / rhs->X y:Y / rhs->Y];
}

- (id)vectorByDividingWithScalar:(float)rhs;
{
	return [[self class] vectorWithX:X / rhs y:Y / rhs];
}

- (float)dotProduct:(Vector2*)rhs;
{
	return X * rhs->X + Y * rhs->Y;
}

- (float)crossProduct:(Vector2*)rhs;
{
	return X * rhs->Y - Y * rhs->X;
}

- (id)invertedVector;
{
	return [[self class] vectorWithX:-X y:-Y];
}

- (id)normalizedVector;
{
	float invLen = 1.0 / [self length];
	return [[self class] vectorWithX:X * invLen y:Y * invLen];
}

- (float)length;
{
	return sqrtf(X * X + Y * Y);
}

- (float)squaredLength;
{
	return X * X + Y * Y;
}

- (float)distance:(Vector2*)vector;
{
	return [[self vectorBySubtractingVector:vector] length];
}

- (float)squaredDistance:(Vector2*)vector;
{
	return [[self vectorBySubtractingVector:vector] squaredLength];
}

- (id)reflect:(Vector2*)normal;
{
	return [self vectorBySubtractingVector:[normal vectorByMultiplyingWithScalar:([self dotProduct:normal] * 2)]];
}

- (id)midPoint:(Vector2*)vector;
{
	return [[self class] vectorWithX:(X + vector->X) * 0.5 y:(Y + vector->Y) * 0.5];
}

- (NSString*)description;
{
	return [NSString stringWithFormat:@"(%.2f, %.2f)", X, Y];
}

@end

@implementation MutableVector2

@dynamic x;
@dynamic y;

- (void)setX:(float)x;
{
	X = x;
}

- (void)setY:(float)y;
{
	Y = y;
}

- (void)setCoord:(NSUInteger)coord value:(float)value;
{
	NSAssert(2 > coord, @"Illegal coordinate");
	*(v + coord) = value;
}

- (float*)mutableCoordsPtr;
{
	return v;
}

- (float*)mutableCoordsPtr:(NSUInteger)coord;
{
	NSAssert(2 > coord, @"Illegal coordinate");
	return v + coord;
}

- (id)addVector:(Vector2*)rhs;
{
	X += rhs->X;
	Y += rhs->Y;
	
	return self;
}

- (id)addScalar:(float)rhs;
{
	X += rhs;
	Y += rhs;
	
	return self;
}

- (id)subtractVector:(Vector2*)rhs;
{
	X -= rhs->X;
	Y -= rhs->Y;
	
	return self;
}

- (id)subtractScalar:(float)rhs;
{
	X -= rhs;
	Y -= rhs;
	
	return self;
}

- (id)multiplyWithVector:(Vector2*)rhs;
{
	X *= rhs->X;
	Y *= rhs->Y;
	
	return self;
}

- (id)multiplyWithScalar:(float)rhs;
{
	X *= rhs;
	Y *= rhs;
	
	return self;
}

- (id)divideWithVector:(Vector2*)rhs;
{
	X /= rhs->X;
	Y /= rhs->Y;
	
	return self;
}

- (id)divideWithScalar:(float)rhs;
{
	X /= rhs;
	Y /= rhs;
	
	return self;
}

- (id)invert;
{
	X = -X;
	Y = -Y;
	
	return self;
}

- (id)normalize;
{
	float invLen = 1.0 / [self length];
	
	X *= invLen;
	Y *= invLen;
	
	return self;
}

@end
