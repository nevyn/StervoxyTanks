#import <Foundation/Foundation.h>

@class Matrix4;
@class Plane;
@class Vector3;

@interface Frustum : NSObject
{
	Plane *nearPlane;
	Plane *farPlane;
	Plane *leftPlane;
	Plane *rightPlane;
	Plane *topPlane;
	Plane *bottomPlane;
}

@property(readonly, nonatomic) Plane *nearPlane;
@property(readonly, nonatomic) Plane *farPlane;
@property(readonly, nonatomic) Plane *leftPlane;
@property(readonly, nonatomic) Plane *rightPlane;
@property(readonly, nonatomic) Plane *topPlane;
@property(readonly, nonatomic) Plane *bottomPlane;

// Add properties

- (id)initWithNearPlane:(Plane*)near farPlane:(Plane*)far leftPlane:(Plane*)left rightPlane:(Plane*)right topPlane:(Plane*)top bottomPlane:(Plane*)bottom;
- (id)initWithViewProjection:(Matrix4*)viewProjection andNormalizePlanes:(BOOL)normalizeFlag;

- (void)dealloc;

+ (id)frustumWithNearPlane:(Plane*)near farPlane:(Plane*)far leftPlane:(Plane*)left rightPlane:(Plane*)right topPlane:(Plane*)top bottomPlane:(Plane*)bottom;
+ (id)frustumWithViewProjection:(Matrix4*)viewProjection andNormalizePlanes:(BOOL)normalizeFlag;

- (BOOL)containsPoint:(Vector3*)point;
//- (BOOL)intersectsWithSphere:(Sphere*)point;

- (NSString*)description;

@end
