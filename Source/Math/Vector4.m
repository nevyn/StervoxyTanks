#import "Vector4.h"

#import <math.h>
#import <memory.h>
#import "Vector2.h"
#import "Vector3.h"

Vec4 makeVec4(float x, float y, float z, float w)
{
	Vec4 v;
	v.x = x;
	v.y = y;
	v.z = z;
	v.w = w;
	
	return v;
}

static Vector4 *zero;
static Vector4 *xAxis;
static Vector4 *yAxis;
static Vector4 *zAxis;
static Vector4 *wAxis;
static Vector4 *negativeXAxis;
static Vector4 *negativeYAxis;
static Vector4 *negativeZAxis;
static Vector4 *negativeWAxis;

#define X v[0]
#define Y v[1]
#define Z v[2]
#define W v[3]

@implementation Vector4

- (float)x;
{
	return X;
}

- (float)y;
{
	return Y;
}

- (float)z;
{
	return Z;
}

- (float)w;
{
	return W;
}

+ (void)initialize;
{
	zero = [[Vector4 alloc] init];
	xAxis = [[Vector4 alloc] initWithX:1 y:0 z:0 w:0];
	yAxis = [[Vector4 alloc] initWithX:0 y:1 z:0 w:0];
	zAxis = [[Vector4 alloc] initWithX:0 y:0 z:1 w:0];
	wAxis = [[Vector4 alloc] initWithX:0 y:0 z:0 w:1];
	negativeXAxis = [[Vector4 alloc] initWithX:-1 y:0 z:0 w:0];
	negativeYAxis = [[Vector4 alloc] initWithX:0 y:-1 z:0 w:0];
	negativeZAxis = [[Vector4 alloc] initWithX:0 y:0 z:-1 w:0];
	negativeWAxis = [[Vector4 alloc] initWithX:0 y:0 z:0 w:-1];
}

+ (Vector4*)zero;
{
	return zero;
}

+ (Vector4*)xAxis;
{
	return xAxis;
}

+ (Vector4*)yAxis;
{
	return yAxis;
}

+ (Vector4*)zAxis;
{
	return zAxis;
}

+ (Vector4*)wAxis;
{
	return wAxis;
}

+ (Vector4*)negativeXAxis;
{
	return negativeXAxis;
}

+ (Vector4*)negativeYAxis;
{
	return negativeYAxis;
}

+ (Vector4*)negativeZAxis;
{
	return negativeZAxis;
}

+ (Vector4*)negativeWAxis;
{
	return negativeWAxis;
}

- (id)init;
{
	return [self initWithX:0 y:0 z:0 w:0];
}

- (id)initWithX:(float)x y:(float)y z:(float)z w:(float)w;
{
	float *vals = malloc(sizeof (float) * 4);
	vals[0] = x;
	vals[1] = y;
	vals[2] = z;
	vals[3] = w;
	
	if (![self initWithMemory:vals memoryResponsibility:Vector4MemoryResponsibilityFree])
	{
		free(vals);
		return nil;
	}
	
	return self;
}

- (id)initWithMemory:(float*)vals memoryResponsibility:(Vector4MemoryResponsibility)responsibility_;
{
	responsibility = responsibility_;
	
	if (responsibility == Vector4MemoryResponsibilityCopy)
		return [self initWithX:vals[0] y:vals[1] z:vals[2] w:vals[3]];
	
	v = vals;
	
	return self;
}

- (id)initWithVector2:(Vector2*)vector z:(float)z w:(float)w;
{
	return [self initWithX:[vector x] y:[vector y] z:z w:w];
}

- (id)initWithVector3:(Vector3*)vector w:(float)w;
{
	return [self initWithX:[vector x] y:[vector y] z:[vector z] w:w];
}

- (id)initWithVector4:(Vector4*)vector;
{
	return [self initWithX:vector->X y:vector->Y z:vector->Z w:vector->W];
}

- (id)initWithVec2:(Vec2)vec z:(float)z w:(float)w;
{
	return [self initWithX:vec.x y:vec.y z:z w:w];
}

- (id)initWithVec3:(Vec3)vec w:(float)w;
{
	return [self initWithX:vec.x y:vec.y z:vec.z w:w];
}

- (id)initWithVec4:(Vec4)vec;
{
	return [self initWithX:vec.x y:vec.y z:vec.z w:vec.w];
}

- (id)initWithScalar:(float)scalar;
{
	return [self initWithX:scalar y:scalar z:scalar w:scalar];
}

- (void)dealloc;
{
	if (responsibility == Vector4MemoryResponsibilityFree)
		free(v);
	
	[super dealloc];
}

+ (id)vector;
{
	return [[[[self class] alloc] init] autorelease];
}

+ (id)vectorWithX:(float)x y:(float)y z:(float)z w:(float)w;
{
	return [[[[self class] alloc] initWithX:x y:y z:z w:w] autorelease];
}

+ (id)vectorWithMemory:(float*)vals memoryResponsibility:(Vector4MemoryResponsibility)responsibility_;
{
	return [[[[self class] alloc] initWithMemory:vals memoryResponsibility:responsibility_] autorelease];
}

+ (id)vectorWithVector2:(Vector2*)vector z:(float)z w:(float)w;
{
	return [[[[self class] alloc] initWithVector2:vector z:z w:w] autorelease];
}

+ (id)vectorWithVector3:(Vector3*)vector w:(float)w;
{
	return [[[[self class] alloc] initWithVector3:vector w:w] autorelease];
}

+ (id)vectorWithVector4:(Vector4*)vector;
{
	return [[[[self class] alloc] initWithVector4:vector] autorelease];
}

+ (id)vectorWithVec2:(Vec2)vec z:(float)z w:(float)w;
{
	return [[[[self class] alloc] initWithVec2:vec z:z w:w] autorelease];
}

+ (id)vectorWithVec3:(Vec3)vec w:(float)w;
{
	return [[[[self class] alloc] initWithVec3:vec w:w] autorelease];
}

+ (id)vectorWithVec4:(Vec4)vec;
{
	return [[[[self class] alloc] initWithVec4:vec] autorelease];
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
	return [[MutableVector4 alloc] initWithVector4:self];
}

- (BOOL)isEqual:(Vector4*)vector;
{
	return X == vector->X && Y == vector->Y && Z == vector->Z && W == vector->W;
}

- (NSComparisonResult)compare:(Vector4*)vector;
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
	NSAssert(4 > coord, @"Illegal coordinate");
	return *(v + coord);
}

- (const float*)coordsPtr;
{
	return v;
}

- (const float*)coordsPtr:(NSUInteger)coord;
{
	NSAssert(4 > coord, @"Illegal coordinate");
	return (v + coord);
}

- (id)vectorByAddingVector:(Vector4*)rhs;
{
	return [[self class] vectorWithX:X + rhs->X y:Y + rhs->Y z:Z + rhs->Z w:W + rhs->W];
}

- (id)vectorByAddingScalar:(float)rhs;
{
	return [[self class] vectorWithX:X + rhs y:Y + rhs z:Z + rhs w:W + rhs];
}

- (id)vectorBySubtractingVector:(Vector4*)rhs;
{
	return [[self class] vectorWithX:X - rhs->X y:Y - rhs->Y z:Z - rhs->Z w:W - rhs->W];
}

- (id)vectorBySubtractingScalar:(float)rhs;
{
	return [[self class] vectorWithX:X - rhs y:Y - rhs z:Z - rhs w:W - rhs];
}

- (id)vectorByMultiplyingWithVector:(Vector4*)rhs;
{
	return [[self class] vectorWithX:X * rhs->X y:Y * rhs->Y z:Z * rhs->Z w:W * rhs->W];
}

- (id)vectorByMultiplyingWithScalar:(float)rhs;
{
	return [[self class] vectorWithX:X * rhs y:Y * rhs z:Z * rhs w:W * rhs];
}

- (id)vectorByDividingWithVector:(Vector4*)rhs;
{
	return [[self class] vectorWithX:X / rhs->X y:Y / rhs->Y z:Z / rhs->Z w:W / rhs->W];
}

- (id)vectorByDividingWithScalar:(float)rhs;
{
	return [[self class] vectorWithX:X / rhs y:Y / rhs z:Z / rhs w:W / rhs];
}

- (float)dotProduct:(Vector4*)rhs;
{
	return X * rhs->X + Y * rhs->Y + Z * rhs->Z + W * rhs->W;
}

- (id)invertedVector;
{
	return [[self class] vectorWithX:-X y:-Y z:-Z w:-W];
}

- (id)normalizedVector;
{
	float invLen = 1.0 / [self length];
	return [[self class] vectorWithX:X * invLen y:Y * invLen z:Z * invLen w:W * invLen];
}

- (float)length;
{
	return sqrtf(X * X + Y * Y + Z * Z + W * W);
}

- (float)squaredLength;
{
	return X * X + Y * Y + Z * Z + W * W;
}

- (float)distance:(Vector4*)vector;
{
	return [[self vectorBySubtractingVector:vector] length];
}

- (float)squaredDistance:(Vector4*)vector;
{
	return [[self vectorBySubtractingVector:vector] squaredLength];
}

- (NSString*)description;
{
	return [NSString stringWithFormat:@"(%.2f, %.2f, %.2f, %2f)", X, Y, Z, W];
}

@end

@implementation MutableVector4

@dynamic x;
@dynamic y;
@dynamic z;
@dynamic w;

- (void)setX:(float)x;
{
	X = x;
}

- (void)setY:(float)y;
{
	Y = y;
}

- (void)setZ:(float)z;
{
	Z = z;
}

- (void)setW:(float)w;
{
	W = w;
}

- (void)setCoord:(NSUInteger)coord value:(float)value;
{
	NSAssert(4 > coord, @"Illegal coordinate");
	*(v + coord) = value;
}

- (float*)mutableCoordsPtr;
{
	return v;
}

- (float*)mutableCoordsPtr:(NSUInteger)coord;
{
	NSAssert(4 > coord, @"Illegal coordinate");
	return v + coord;
}

- (id)addVector:(Vector4*)rhs;
{
	X += rhs->X;
	Y += rhs->Y;
	Z += rhs->Z;
	W += rhs->W;
	
	return self;
}

- (id)addScalar:(float)rhs;
{
	X += rhs;
	Y += rhs;
	Z += rhs;
	W += rhs;
	
	return self;
}

- (id)subtractVector:(Vector4*)rhs;
{
	X -= rhs->X;
	Y -= rhs->Y;
	Z -= rhs->Z;
	W -= rhs->W;
	
	return self;
}

- (id)subtractScalar:(float)rhs;
{
	X -= rhs;
	Y -= rhs;
	Z -= rhs;
	W -= rhs;
	
	return self;
}

- (id)multiplyWithVector:(Vector4*)rhs;
{
	X *= rhs->X;
	Y *= rhs->Y;
	Z *= rhs->Z;
	W *= rhs->W;
	
	return self;
}

- (id)multiplyWithScalar:(float)rhs;
{
	X *= rhs;
	Y *= rhs;
	Z *= rhs;
	W *= rhs;
	
	return self;
}

- (id)divideWithVector:(Vector4*)rhs;
{
	X /= rhs->X;
	Y /= rhs->Y;
	Z /= rhs->Z;
	W /= rhs->W;
	
	return self;
}

- (id)divideWithScalar:(float)rhs;
{
	X /= rhs;
	Y /= rhs;
	Z /= rhs;
	W /= rhs;
	
	return self;
}

- (id)invert;
{
	X = -X;
	Y = -Y;
	Z = -Z;
	W = -W;
	
	return self;
}

- (id)normalize;
{
	float invLen = 1.0 / [self length];
	
	X *= invLen;
	Y *= invLen;
	Z *= invLen;
	W *= invLen;
	
	return self;
}

@end
