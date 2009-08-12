#import <Foundation/Foundation.h>
#import "Vector2.h"

typedef struct
{
	float x, y, z;
} Vec3;

Vec3 makeVec3(float x, float y, float z);

typedef enum
{
	Vector3MemoryResponsibilityFree,
	Vector3MemoryResponsibilityCopy,
	Vector3MemoryResponsibilityNone
} Vector3MemoryResponsibility;

@interface Vector3 : NSObject <NSCopying, NSMutableCopying>
{
	float *v;
	Vector3MemoryResponsibility responsibility;
}

@property(readonly, nonatomic) float x;
@property(readonly, nonatomic) float y;
@property(readonly, nonatomic) float z;
// Add rgb and stp properties? Might be inconsistent since Vec3 wont have these members (no support for anonymous union in C).

+ (Vector3*)zero;
+ (Vector3*)xAxis;
+ (Vector3*)yAxis;
+ (Vector3*)zAxis;
+ (Vector3*)negativeXAxis;
+ (Vector3*)negativeYAxis;
+ (Vector3*)negativeZAxis;

- (id)init;
- (id)initWithX:(float)x y:(float)y z:(float)z;
- (id)initWithMemory:(float*)vals memoryResponsibility:(Vector3MemoryResponsibility)responsibility_;
- (id)initWithVector2:(Vector2*)vector z:(float)z;
- (id)initWithVector3:(Vector3*)vector;
- (id)initWithVec2:(Vec2)vec z:(float)z;
- (id)initWithVec3:(Vec3)vec;
- (id)initWithScalar:(float)scalar;

- (void)dealloc;

+ (id)vector;
+ (id)vectorWithX:(float)x y:(float)y z:(float)z;
+ (id)vectorWithMemory:(float*)vals memoryResponsibility:(Vector3MemoryResponsibility)responsibility_;
+ (id)vectorWithVector2:(Vector2*)vector z:(float)z;
+ (id)vectorWithVector3:(Vector3*)vector;
+ (id)vectorWithVec2:(Vec2)vec z:(float)z;
+ (id)vectorWithVec3:(Vec3)vec;
+ (id)vectorWithScalar:(float)scalar;

- (id)copyWithZone:(NSZone*)zone;
- (id)mutableCopyWithZone:(NSZone*)zone;

- (BOOL)isEqual:(Vector3*)vector;
- (NSComparisonResult)compare:(Vector3*)vector;

- (float)coord:(NSUInteger)coord;

- (const float*)coordsPtr;
- (const float*)coordsPtr:(NSUInteger)coord;

- (id)vectorByAddingVector:(Vector3*)rhs;
- (id)vectorByAddingScalar:(float)rhs;
- (id)vectorBySubtractingVector:(Vector3*)rhs;
- (id)vectorBySubtractingScalar:(float)rhs;
- (id)vectorByMultiplyingWithVector:(Vector3*)rhs;
- (id)vectorByMultiplyingWithScalar:(float)rhs;
- (id)vectorByDividingWithVector:(Vector3*)rhs;
- (id)vectorByDividingWithScalar:(float)rhs;

- (float)dotProduct:(Vector3*)rhs;
- (id)crossProduct:(Vector3*)rhs;

- (id)invertedVector;
- (id)normalizedVector;

- (float)length;
- (float)squaredLength;
- (float)distance:(Vector3*)vector;
- (float)squaredDistance:(Vector3*)vector;

- (id)reflect:(Vector3*)normal;
- (id)midPoint:(Vector3*)vector;
- (float)angleBetween:(Vector3*)vector;

- (id)rotatedAboutXAxisAtAngle:(float)angle; // Add to mutable, Vector2, and Vector4.
- (id)rotatedAboutYAxisAtAngle:(float)angle; // Add to mutable, Vector2, and Vector4.
- (id)rotatedAboutZAxisAtAngle:(float)angle; // Add to mutable, Vector2, and Vector4.
- (id)rotatedAboutAxis:(Vector3*)axis atAngle:(float)angle; // Add to mutable, Vector2, and Vector4.

- (NSString*)description;

@end

@interface MutableVector3 : Vector3
{
}

@property(readwrite, nonatomic) float x;
@property(readwrite, nonatomic) float y;
@property(readwrite, nonatomic) float z;

- (void)setCoord:(NSUInteger)coord value:(float)value;

- (float*)mutableCoordsPtr;
- (float*)mutableCoordsPtr:(NSUInteger)coord;

- (id)addVector:(Vector3*)rhs;
- (id)addScalar:(float)rhs;
- (id)subtractVector:(Vector3*)rhs;
- (id)subtractScalar:(float)rhs;
- (id)multiplyWithVector:(Vector3*)rhs;
- (id)multiplyWithScalar:(float)rhs;
- (id)divideWithVector:(Vector3*)rhs;
- (id)divideWithScalar:(float)rhs;

- (id)invert;
- (id)normalize;

@end
