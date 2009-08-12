#import <Foundation/Foundation.h>

typedef struct
{
	float x, y;
} Vec2;

Vec2 makeVec2(float x, float y);

typedef enum
{
	Vector2MemoryResponsibilityFree,
	Vector2MemoryResponsibilityCopy,
	Vector2MemoryResponsibilityNone
} Vector2MemoryResponsibility;

@interface Vector2 : NSObject <NSCopying, NSMutableCopying>
{
	float *v;
	Vector2MemoryResponsibility responsibility;
}

@property(readonly, nonatomic) float x;
@property(readonly, nonatomic) float y;

+ (Vector2*)zero;
+ (Vector2*)xAxis;
+ (Vector2*)yAxis;
+ (Vector2*)negativeXAxis;
+ (Vector2*)negativeYAxis;

- (id)init;
- (id)initWithX:(float)x y:(float)y;
- (id)initWithMemory:(float*)vals memoryResponsibility:(Vector2MemoryResponsibility)responsibility_;
- (id)initWithVector2:(Vector2*)vector;
- (id)initWithVec2:(Vec2)vec;
- (id)initWithScalar:(float)scalar;

- (void)dealloc;

+ (id)vector;
+ (id)vectorWithX:(float)x y:(float)y;
+ (id)vectorWithMemory:(float*)vals memoryResponsibility:(Vector2MemoryResponsibility)responsibility_;
+ (id)vectorWithVector2:(Vector2*)vector;
+ (id)vectorWithVec2:(Vec2)vec;
+ (id)vectorWithScalar:(float)scalar;

- (id)copyWithZone:(NSZone*)zone;
- (id)mutableCopyWithZone:(NSZone*)zone;

- (BOOL)isEqual:(Vector2*)vector;
- (NSComparisonResult)compare:(Vector2*)vector;

- (float)coord:(NSUInteger)coord;

- (const float*)coordsPtr;
- (const float*)coordsPtr:(NSUInteger)coord;

- (id)vectorByAddingVector:(Vector2*)rhs;
- (id)vectorByAddingScalar:(float)rhs;
- (id)vectorBySubtractingVector:(Vector2*)rhs;
- (id)vectorBySubtractingScalar:(float)rhs;
- (id)vectorByMultiplyingWithVector:(Vector2*)rhs;
- (id)vectorByMultiplyingWithScalar:(float)rhs;
- (id)vectorByDividingWithVector:(Vector2*)rhs;
- (id)vectorByDividingWithScalar:(float)rhs;

- (float)dotProduct:(Vector2*)rhs;
- (float)crossProduct:(Vector2*)rhs;

- (id)invertedVector;
- (id)normalizedVector;

- (float)length;
- (float)squaredLength;
- (float)distance:(Vector2*)vector;
- (float)squaredDistance:(Vector2*)vector;

- (id)reflect:(Vector2*)normal;
- (id)midPoint:(Vector2*)vector;

- (NSString*)description;

@end

@interface MutableVector2 : Vector2
{
}

@property(readwrite, nonatomic) float x;
@property(readwrite, nonatomic) float y;

- (void)setCoord:(NSUInteger)coord value:(float)value;

- (float*)mutableCoordsPtr;
- (float*)mutableCoordsPtr:(NSUInteger)coord;

- (id)addVector:(Vector2*)rhs;
- (id)addScalar:(float)rhs;
- (id)subtractVector:(Vector2*)rhs;
- (id)subtractScalar:(float)rhs;
- (id)multiplyWithVector:(Vector2*)rhs;
- (id)multiplyWithScalar:(float)rhs;
- (id)divideWithVector:(Vector2*)rhs;
- (id)divideWithScalar:(float)rhs;

- (id)invert;
- (id)normalize;

@end
