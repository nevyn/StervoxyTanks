#import "Vector3.h"

#import <math.h>
#import <memory.h>

Vec3 makeVec3(float x, float y, float z)
{
	Vec3 v;
	
	v.x = x;
	v.y = y;
	v.z = z;
	
	return v;
}

static Vector3 *zero;
static Vector3 *xAxis;
static Vector3 *yAxis;
static Vector3 *zAxis;
static Vector3 *negativeXAxis;
static Vector3 *negativeYAxis;
static Vector3 *negativeZAxis;

#define X v[0]
#define Y v[1]
#define Z v[2]

@implementation Vector3

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

+ (void)initialize;
{
	zero = [[Vector3 alloc] init];
	xAxis = [[Vector3 alloc] initWithX:1 y:0 z:0];
	yAxis = [[Vector3 alloc] initWithX:0 y:1 z:0];
	zAxis = [[Vector3 alloc] initWithX:0 y:0 z:1];
	negativeXAxis = [[Vector3 alloc] initWithX:-1 y:0 z:0];
	negativeYAxis = [[Vector3 alloc] initWithX:0 y:-1 z:0];
	negativeZAxis = [[Vector3 alloc] initWithX:0 y:0 z:-1];
}

+ (Vector3*)zero;
{
	return zero;
}

+ (Vector3*)xAxis;
{
	return xAxis;
}

+ (Vector3*)yAxis;
{
	return yAxis;
}

+ (Vector3*)zAxis;
{
	return zAxis;
}

+ (Vector3*)negativeXAxis;
{
	return negativeXAxis;
}

+ (Vector3*)negativeYAxis;
{
	return negativeYAxis;
}

+ (Vector3*)negativeZAxis;
{
	return negativeZAxis;
}

- (id)init;
{
	return [self initWithX:0 y:0 z:0];
}

- (id)initWithX:(float)x y:(float)y z:(float)z;
{
	float *vals = malloc(sizeof (float) * 3);
	vals[0] = x;
	vals[1] = y;
	vals[2] = z;
	
	if (![self initWithMemory:vals memoryResponsibility:Vector3MemoryResponsibilityFree])
	{
		free(vals);
		return nil;
	}
	
	return self;
}

- (id)initWithMemory:(float*)vals memoryResponsibility:(Vector3MemoryResponsibility)responsibility_;
{
	responsibility = responsibility_;
	
	if (responsibility == Vector3MemoryResponsibilityCopy)
		return [self initWithX:vals[0] y:vals[1] z:vals[2]];
	
	v = vals;
	
	return self;
}

- (id)initWithVector2:(Vector2*)vector z:(float)z;
{
	return [self initWithX:[vector x] y:[vector y] z:z];
}

- (id)initWithVector3:(Vector3*)vector;
{
	return [self initWithX:vector->X y:vector->Y z:vector->Z];
}

- (id)initWithVec2:(Vec2)vec z:(float)z;
{
	return [self initWithX:vec.x y:vec.y z:z];
}

- (id)initWithVec3:(Vec3)vec;
{
	return [self initWithX:vec.x y:vec.y z:vec.z];
}

- (id)initWithScalar:(float)scalar;
{
	return [self initWithX:scalar y:scalar z:scalar];
}

- (void)dealloc;
{
	if (responsibility == Vector3MemoryResponsibilityFree)
		free(v);
	
	[super dealloc];
}

+ (id)vector;
{
	return [[[[self class] alloc] init] autorelease];
}

+ (id)vectorWithX:(float)x y:(float)y z:(float)z;
{
	return [[[[self class] alloc] initWithX:x y:y z:z] autorelease];
}

+ (id)vectorWithMemory:(float*)vals memoryResponsibility:(Vector3MemoryResponsibility)responsibility_;
{
	return [[[[self class] alloc] initWithMemory:vals memoryResponsibility:responsibility_] autorelease];
}

+ (id)vectorWithVector2:(Vector2*)vector z:(float)z;
{
	return [[[[self class] alloc] initWithVector2:vector z:z] autorelease];
}

+ (id)vectorWithVector3:(Vector3*)vector;
{
	return [[[[self class] alloc] initWithVector3:vector] autorelease];
}

+ (id)vectorWithVec2:(Vec2)vec z:(float)z;
{
	return [[[[self class] alloc] initWithVec2:vec z:z] autorelease];
}

+ (id)vectorWithVec3:(Vec3)vec;
{
	return [[[[self class] alloc] initWithVec3:vec] autorelease];
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
	return [[MutableVector3 alloc] initWithVector3:self];
}

- (BOOL)isEqual:(Vector3*)vector;
{
	return X == vector->X && Y == vector->Y && Z == vector->Z;
}

- (NSComparisonResult)compare:(Vector3*)vector;
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
	NSAssert(3 > coord, @"Illegal coordinate");
	return *(v + coord);
}

- (const float*)coordsPtr;
{
	return v;
}

- (const float*)coordsPtr:(NSUInteger)coord;
{
	NSAssert(3 > coord, @"Illegal coordinate");
	return (v + coord);
}

- (id)vectorByAddingVector:(Vector3*)rhs;
{
	return [[self class] vectorWithX:X + rhs->X y:Y + rhs->Y z:Z + rhs->Z];
}

- (id)vectorByAddingScalar:(float)rhs;
{
	return [[self class] vectorWithX:X + rhs y:Y + rhs z:Z + rhs];
}

- (id)vectorBySubtractingVector:(Vector3*)rhs;
{
	return [[self class] vectorWithX:X - rhs->X y:Y - rhs->Y z:Z - rhs->Z];
}

- (id)vectorBySubtractingScalar:(float)rhs;
{
	return [[self class] vectorWithX:X - rhs y:Y - rhs z:Z - rhs];
}

- (id)vectorByMultiplyingWithVector:(Vector3*)rhs;
{
	return [[self class] vectorWithX:X * rhs->X y:Y * rhs->Y z:Z * rhs->Z];
}

- (id)vectorByMultiplyingWithScalar:(float)rhs;
{
	return [[self class] vectorWithX:X * rhs y:Y * rhs z:Z * rhs];
}

- (id)vectorByDividingWithVector:(Vector3*)rhs;
{
	return [[self class] vectorWithX:X / rhs->X y:Y / rhs->Y z:Z / rhs->Z];
}

- (id)vectorByDividingWithScalar:(float)rhs;
{
	return [[self class] vectorWithX:X / rhs y:Y / rhs z:Z / rhs];
}

- (float)dotProduct:(Vector3*)rhs;
{
	return X * rhs->X + Y * rhs->Y + Z * rhs->Z;
}

- (id)crossProduct:(Vector3*)rhs;
{
	return [[self class] vectorWithX:Y * rhs->Z - Z * rhs->Y y:Z * rhs->X - X * rhs->Z z:X * rhs->Y - Y * rhs->X];
}

- (id)invertedVector;
{
	return [[self class] vectorWithX:-X y:-Y z:-Z];
}

- (id)normalizedVector;
{
	float invLen = 1.0 / [self length];
	return [[self class] vectorWithX:X * invLen y:Y * invLen z:Z * invLen];
}

- (float)length;
{
	return sqrtf(X * X + Y * Y + Z * Z);
}

- (float)squaredLength;
{
	return X * X + Y * Y + Z * Z;
}

- (float)distance:(Vector3*)vector;
{
	return [[self vectorBySubtractingVector:vector] length];
}

- (float)squaredDistance:(Vector3*)vector;
{
	return [[self vectorBySubtractingVector:vector] squaredLength];
}

- (id)reflect:(Vector3*)normal;
{
	return [self vectorBySubtractingVector:[normal vectorByMultiplyingWithScalar:([self dotProduct:normal] * 2)]];
}

- (id)midPoint:(Vector3*)vector;
{
	return [[self class] vectorWithX:(X + vector->X) * 0.5 y:(Y + vector->Y) * 0.5 z:(Z + vector->Z) * 0.5];
}

- (float)angleBetween:(Vector3*)vector;
{
	float lenProduct = [self length] * [vector length];
	
	if (lenProduct < 1e-6f)
		lenProduct = 1e-6f;
	
	float f = [self dotProduct:vector] / lenProduct;
	
	return acosf(f < -1.0 ? -1.0 : (f > 1.0 ? 1.0 : f));
}

- (id)rotatedAboutXAxisAtAngle:(float)angle;
{
	float s = sinf(angle);
	float c = cosf(angle);
	
	return [[self class] vectorWithX:X y:c * Y - s * Z z:c * Z + s * Y];
}

- (id)rotatedAboutYAxisAtAngle:(float)angle;
{
	float s = sinf(angle);
	float c = cosf(angle);
	
	return [[self class] vectorWithX:c * X + s * Z y:Y z:c * Z - s * X];
}

- (id)rotatedAboutZAxisAtAngle:(float)angle;
{
	float s = sinf(angle);
	float c = cosf(angle);
	
	return [[self class] vectorWithX:c * X - s * Y y:c * Y + s * X z:Z];
}

- (id)rotatedAboutAxis:(Vector3*)axis atAngle:(float)angle;
{
    float s = sinf(angle);
    float c = cosf(angle);
    float k = 1.0 - c;
	
	float kxy = k * axis->X * axis->Y;
	float kxz = k * axis->X * axis->Z;
	float kyz = k * axis->Y * axis->Z;
	float sx = s * axis->X;
	float sy = s * axis->Y;
	float sz = s * axis->Z;
    
	return [[self class] vectorWithX:X * (c + k * axis->X * axis->X) + Y * (kxy - sz) + Z * (kxz + sy)
								   y:X * (kxy + sz) + Y * (c + k * axis->Y * axis->Y) + Z * (kyz - sx)
								   z:X * (kxz - sy) + Y * (kyz + sx) + Z * (c + k * axis->Z * axis->Z)];
}

- (NSString*)description;
{
	return [NSString stringWithFormat:@"(%.2f, %.2f, %.2f)", X, Y, Z];
}

@end

@implementation MutableVector3

@dynamic x;
@dynamic y;
@dynamic z;

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

- (void)setCoord:(NSUInteger)coord value:(float)value;
{
	NSAssert(3 > coord, @"Illegal coordinate");
	*(v + coord) = value;
}

- (float*)mutableCoordsPtr;
{
	return v;
}

- (float*)mutableCoordsPtr:(NSUInteger)coord;
{
	NSAssert(3 > coord, @"Illegal coordinate");
	return v + coord;
}

- (id)addVector:(Vector3*)rhs;
{
	X += rhs->X;
	Y += rhs->Y;
	Z += rhs->Z;
	
	return self;
}

- (id)addScalar:(float)rhs;
{
	X += rhs;
	Y += rhs;
	Z += rhs;
	
	return self;
}

- (id)subtractVector:(Vector3*)rhs;
{
	X -= rhs->X;
	Y -= rhs->Y;
	Z -= rhs->Z;
	
	return self;
}

- (id)subtractScalar:(float)rhs;
{
	X -= rhs;
	Y -= rhs;
	Z -= rhs;
	
	return self;
}

- (id)multiplyWithVector:(Vector3*)rhs;
{
	X *= rhs->X;
	Y *= rhs->Y;
	Z *= rhs->Z;
	
	return self;
}

- (id)multiplyWithScalar:(float)rhs;
{
	X *= rhs;
	Y *= rhs;
	Z *= rhs;
	
	return self;
}

- (id)divideWithVector:(Vector3*)rhs;
{
	X /= rhs->X;
	Y /= rhs->Y;
	Z /= rhs->Z;
	
	return self;
}

- (id)divideWithScalar:(float)rhs;
{
	X /= rhs;
	Y /= rhs;
	Z /= rhs;
	
	return self;
}

- (id)invert;
{
	X = -X;
	Y = -Y;
	Z = -Z;
	
	return self;
}

- (id)normalize;
{
	float invLen = 1.0 / [self length];
	
	X *= invLen;
	Y *= invLen;
	Z *= invLen;
	
	return self;
}

@end
