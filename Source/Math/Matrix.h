// GLSL versions 1.00 and 1.10 support matrix data types of the form mat2, mat3, mat4.
// GLSL version 1.20 adds support for non-square matrixes: mat2x3, mat2x4, mat3x2, mat3x4, mat4x2, mat4x3.

#import <Foundation/Foundation.h>

@class Vector4;

// Members are stored in column major order to conform with OpenGL.
typedef struct
{
	float m11, m21, m31, m41;
	float m12, m22, m32, m42;
	float m13, m23, m33, m43;
	float m14, m24, m34, m44;
} Mat4;

Mat4 makeMat4(float m11, float m12, float m13, float m14,
			  float m21, float m22, float m23, float m24,
			  float m31, float m32, float m33, float m34,
			  float m41, float m42, float m43, float m44);
//Mat4 makeMat4(float *columnMajorMatrix);
//Mat4 makeMat4FromRowMajor(float *rowMajorMatrix);

//@class Matrix3;

typedef enum {
	Matrix4MemoryResponsibilityFree,
	Matrix4MemoryResponsibilityCopy,
	Matrix4MemoryResponsibilityNone
} Matrix4MemoryResponsibility;

@interface Matrix4 : NSObject <NSCopying, NSMutableCopying>
{
	float *v;
	Matrix4MemoryResponsibility responsibility;
}

@property(readonly, nonatomic) float m11;
@property(readonly, nonatomic) float m12;
@property(readonly, nonatomic) float m13;
@property(readonly, nonatomic) float m14;

@property(readonly, nonatomic) float m21;
@property(readonly, nonatomic) float m22;
@property(readonly, nonatomic) float m23;
@property(readonly, nonatomic) float m24;

@property(readonly, nonatomic) float m31;
@property(readonly, nonatomic) float m32;
@property(readonly, nonatomic) float m33;
@property(readonly, nonatomic) float m34;

@property(readonly, nonatomic) float m41;
@property(readonly, nonatomic) float m42;
@property(readonly, nonatomic) float m43;
@property(readonly, nonatomic) float m44;

+ (Matrix4*)zero;
+ (Matrix4*)identity;

- (id)init;
- (id)initWithM11:(float)m11 m12:(float)m12 m13:(float)m13 m14:(float)m14
			  m21:(float)m21 m22:(float)m22 m23:(float)m23 m24:(float)m24
			  m31:(float)m31 m32:(float)m32 m33:(float)m33 m34:(float)m34
			  m41:(float)m41 m42:(float)m42 m43:(float)m43 m44:(float)m44;
- (id)initWithMemory:(float*)members memoryResponsibility:(Matrix4MemoryResponsibility)responsibility_;
- (id)initWithCArray:(float*)members;
- (id)initWithMatrix4:(Matrix4*)matrix;
- (id)initWithMat4:(Mat4)mat;

- (void)dealloc;

+ (id)matrix;
+ (id)matrixWithM11:(float)m11 m12:(float)m12 m13:(float)m13 m14:(float)m14
				m21:(float)m21 m22:(float)m22 m23:(float)m23 m24:(float)m24
				m31:(float)m31 m32:(float)m32 m33:(float)m33 m34:(float)m34
				m41:(float)m41 m42:(float)m42 m43:(float)m43 m44:(float)m44;
+ (id)matrixWithCArray:(float*)members;
+ (id)matrixWithMemory:(float*)members memoryResponsibility:(Matrix4MemoryResponsibility)responsibility_;
+ (id)matrixWithMatrix4:(Matrix4*)matrix;
+ (id)matrixWithMat4:(Mat4)mat;

- (id)copyWithZone:(NSZone*)zone;
- (id)mutableCopyWithZone:(NSZone*)zone;

//- (BOOL)isEqual:(id)matrix;
//- (NSComparisonResult)compare:(id)matrix;

- (float)element:(NSUInteger)element;
- (float)elementAtRow:(NSUInteger)row column:(NSUInteger)column;

- (const float*)elements;
- (const float*)elementPtrToColumn:(NSUInteger)column;
- (const float*)elementPtrToColumn:(NSUInteger)column row:(NSUInteger)row;

- (id)matrixByMultiplyingWithMatrix:(Matrix4*)rhs;

- (Vector4*)vectorByMultiplyingWithVector:(Vector4*)rhs;

//- (id)concatenated:(id)rhs;
//- (id)transposed;

- (NSString*)description;

@end

@interface MutableMatrix4 : Matrix4
{
}

@end
