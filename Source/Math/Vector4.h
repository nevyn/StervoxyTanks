#import <Foundation/Foundation.h>
#import "Vector2.h"
#import "Vector3.h"

typedef struct
{
	float x, y, z, w;
} Vec4;

Vec4 makeVec4(float x, float y, float z, float w);

typedef enum
{
	Vector4MemoryResponsibilityFree,
	Vector4MemoryResponsibilityCopy,
	Vector4MemoryResponsibilityNone
} Vector4MemoryResponsibility;

@interface Vector4 : NSObject <NSCopying, NSMutableCopying>
{
	float *v;
	Vector4MemoryResponsibility responsibility;
}

@property(readonly, nonatomic) float x;
@property(readonly, nonatomic) float y;
@property(readonly, nonatomic) float z;
@property(readonly, nonatomic) float w;

+ (Vector4*)zero;
+ (Vector4*)xAxis;
+ (Vector4*)yAxis;
+ (Vector4*)zAxis;
+ (Vector4*)wAxis;
+ (Vector4*)negativeXAxis;
+ (Vector4*)negativeYAxis;
+ (Vector4*)negativeZAxis;
+ (Vector4*)negativeWAxis;

- (id)init;
- (id)initWithX:(float)x y:(float)y z:(float)z w:(float)w;
- (id)initWithMemory:(float*)vals memoryResponsibility:(Vector4MemoryResponsibility)responsibility_;
- (id)initWithVector2:(Vector2*)vector z:(float)z w:(float)w;
- (id)initWithVector3:(Vector3*)vector w:(float)w;
- (id)initWithVector4:(Vector4*)vector;
- (id)initWithVec2:(Vec2)vec z:(float)z w:(float)w;
- (id)initWithVec3:(Vec3)vec w:(float)w;
- (id)initWithVec4:(Vec4)vec;
- (id)initWithScalar:(float)scalar;

- (void)dealloc;

+ (id)vector;
+ (id)vectorWithX:(float)x y:(float)y z:(float)z w:(float)w;
+ (id)vectorWithMemory:(float*)vals memoryResponsibility:(Vector4MemoryResponsibility)responsibility_;
+ (id)vectorWithVector2:(Vector2*)vector z:(float)z w:(float)w;
+ (id)vectorWithVector3:(Vector3*)vector w:(float)w;
+ (id)vectorWithVector4:(Vector4*)vector;
+ (id)vectorWithVec2:(Vec2)vec z:(float)z w:(float)w;
+ (id)vectorWithVec3:(Vec3)vec w:(float)w;
+ (id)vectorWithVec4:(Vec4)vec;
+ (id)vectorWithScalar:(float)scalar;

- (id)copyWithZone:(NSZone*)zone;
- (id)mutableCopyWithZone:(NSZone*)zone;

- (BOOL)isEqual:(Vector4*)vector;
- (NSComparisonResult)compare:(Vector4*)vector;

- (float)coord:(NSUInteger)coord;

- (const float*)coordsPtr;
- (const float*)coordsPtr:(NSUInteger)coord;

- (id)vectorByAddingVector:(Vector4*)rhs;
- (id)vectorByAddingScalar:(float)rhs;
- (id)vectorBySubtractingVector:(Vector4*)rhs;
- (id)vectorBySubtractingScalar:(float)rhs;
- (id)vectorByMultiplyingWithVector:(Vector4*)rhs;
- (id)vectorByMultiplyingWithScalar:(float)rhs;
- (id)vectorByDividingWithVector:(Vector4*)rhs;
- (id)vectorByDividingWithScalar:(float)rhs;

- (float)dotProduct:(Vector4*)rhs;

- (id)invertedVector;
- (id)normalizedVector;

- (float)length;
- (float)squaredLength;
- (float)distance:(Vector4*)vector;
- (float)squaredDistance:(Vector4*)vector;

- (NSString*)description;

@end

@interface MutableVector4 : Vector4
{
}

@property(readwrite, nonatomic) float x;
@property(readwrite, nonatomic) float y;
@property(readwrite, nonatomic) float z;
@property(readwrite, nonatomic) float w;

- (void)setCoord:(NSUInteger)coord value:(float)value;

- (float*)mutableCoordsPtr;
- (float*)mutableCoordsPtr:(NSUInteger)coord;

- (id)addVector:(Vector4*)rhs;
- (id)addScalar:(float)rhs;
- (id)subtractVector:(Vector4*)rhs;
- (id)subtractScalar:(float)rhs;
- (id)multiplyWithVector:(Vector4*)rhs;
- (id)multiplyWithScalar:(float)rhs;
- (id)divideWithVector:(Vector4*)rhs;
- (id)divideWithScalar:(float)rhs;

- (id)invert;
- (id)normalize;

@end
