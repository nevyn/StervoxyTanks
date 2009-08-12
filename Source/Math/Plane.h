#import <Foundation/Foundation.h>

@class Vector3;

@interface Plane : NSObject
{
	float a, b, c, d;
}

@property(readonly, nonatomic) float a;
@property(readonly, nonatomic) float b;
@property(readonly, nonatomic) float c;
@property(readonly, nonatomic) float d;

- (id)init;
- (id)initWithA:(float)a_ b:(float)b_ c:(float)c_ d:(float)d_;
- (id)initWithPlane:(Plane*)plane;

+ (id)plane;
+ (id)planeWithA:(float)a_ b:(float)b_ c:(float)c_ d:(float)d_;
+ (id)planeWithPlane:(Plane*)plane;

- (id)copyWithZone:(NSZone*)zone;
- (id)mutableCopyWithZone:(NSZone*)zone;

//- (BOOL)isEqual:(Plane*)plane;
//- (NSComparisonResult)compare:(Plane*)plane;

- (float)element:(NSUInteger)element;

- (const float*)elements;
- (const float*)elementsPtr:(NSUInteger)element;

- (id)normalizedPlane;

- (float)distanceToPoint:(Vector3*)point;

- (NSString*)description;

@end

@interface MutablePlane : Plane
{
}

@end
