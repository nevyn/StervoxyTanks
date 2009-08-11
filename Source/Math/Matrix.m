#import "Matrix.h"

#import <math.h>
#import <memory.h>
#import "Vector4.h"

Mat4 makeMat4(float m11, float m12, float m13, float m14,
			  float m21, float m22, float m23, float m24,
			  float m31, float m32, float m33, float m34,
			  float m41, float m42, float m43, float m44)
{
	Mat4 m;
	
	m.m11 = m11; m.m12 = m12; m.m13 = m13; m.m14 = m14;
	m.m21 = m21; m.m22 = m22; m.m23 = m23; m.m24 = m24;
	m.m31 = m31; m.m32 = m32; m.m33 = m33; m.m34 = m34;
	m.m41 = m41; m.m42 = m42; m.m43 = m43; m.m44 = m44;
	
	return m;
}

/*Mat4 makeMat4(float *columnMajorMatrix)
{
	Mat4 m;
	
	memcpy(&m, columnMajorMatrix, sizeof (float) * 16);
	
	return m;
}

Mat4 makeMat4FromRowMajor(float *rowMajorMatrix)
{
	Mat4 m;
	
#define a(r, c) rowMajorMatrix[r * 4 + c]
	m.m11 = a(1, 1); m.m12 = a(1, 2); m.m13 = a(1, 3); m.m14 = a(1, 4);
	m.m21 = a(2, 1); m.m22 = a(2, 2); m.m23 = a(2, 3); m.m24 = a(2, 4);
	m.m31 = a(3, 1); m.m32 = a(3, 2); m.m33 = a(3, 3); m.m34 = a(3, 4);
	m.m41 = a(4, 1); m.m42 = a(4, 2); m.m43 = a(4, 3); m.m44 = a(4, 4);
#undef a
	
	return m;
}*/

static Matrix4 *zero;
static Matrix4 *identity;

#define M11 v[0]
#define M21 v[1]
#define M31 v[2]
#define M41 v[3]
#define M12 v[4]
#define M22 v[5]
#define M32 v[6]
#define M42 v[7]
#define M13 v[8]
#define M23 v[9]
#define M33 v[10]
#define M43 v[11]
#define M14 v[12]
#define M24 v[13]
#define M34 v[14]
#define M44 v[15]

@implementation Matrix4

- (float)m11; { return M11; }
- (float)m12; { return M12; }
- (float)m13; { return M13; }
- (float)m14; { return M14; }

- (float)m21; { return M21; }
- (float)m22; { return M22; }
- (float)m23; { return M23; }
- (float)m24; { return M24; }

- (float)m31; { return M31; }
- (float)m32; { return M32; }
- (float)m33; { return M33; }
- (float)m34; { return M34; }

- (float)m41; { return M41; }
- (float)m42; { return M42; }
- (float)m43; { return M43; }
- (float)m44; { return M44; }

+ (void)initialize;
{
	zero = [[Vector3 alloc] init];
	identity = [[Matrix4 alloc] initWithM11:1 m12:0 m13:0 m14:0
										m21:0 m22:1 m23:0 m24:0
										m31:0 m32:0 m33:1 m34:0
										m41:0 m42:0 m43:0 m44:1];
}

+ (Matrix4*)zero;
{
	return zero;
}

+ (Matrix4*)identity;
{
	return identity;
}

- (id)init;
{
	float *members = calloc(16, sizeof (float));
	
	if (![self initWithMemory:members memoryResponsibility:Matrix4MemoryResponsibilityFree])
	{
		free(members);
		return nil;
	}
	
	return self;
}

- (id)initWithM11:(float)m11 m12:(float)m12 m13:(float)m13 m14:(float)m14
			  m21:(float)m21 m22:(float)m22 m23:(float)m23 m24:(float)m24
			  m31:(float)m31 m32:(float)m32 m33:(float)m33 m34:(float)m34
			  m41:(float)m41 m42:(float)m42 m43:(float)m43 m44:(float)m44;
{
	float *members = malloc(sizeof (float) * 16);
	
	members[ 0] = m11; members[ 4] = m12; members[ 8] = m13; members[12] = m14;
	members[ 1] = m21; members[ 5] = m22; members[ 9] = m23; members[13] = m24;
	members[ 2] = m31; members[ 6] = m32; members[10] = m33; members[14] = m34;
	members[ 3] = m41; members[ 7] = m42; members[11] = m43; members[15] = m44;
	
	if (![self initWithMemory:members memoryResponsibility:Matrix4MemoryResponsibilityFree])
	{
		free(members);
		return nil;
	}
	
	return self;
}

- (id)initWithMemory:(float*)members memoryResponsibility:(Matrix4MemoryResponsibility)responsibility_;
{
	if (responsibility_ == Matrix4MemoryResponsibilityCopy)
	{
		v = malloc(sizeof (float) * 16);
		memcpy(v, members, sizeof (float) * 16);
		responsibility = Matrix4MemoryResponsibilityFree;
	}
	else
	{
		v = members;
		responsibility = responsibility_;
	}
	
	return self;
}

- (id)initWithCArray:(float*)members;
{
	return [self initWithMemory:members memoryResponsibility:Matrix4MemoryResponsibilityCopy];
}

- (id)initWithMatrix4:(Matrix4*)matrix;
{
	return [self initWithMemory:(float*)[matrix elements] memoryResponsibility:Matrix4MemoryResponsibilityCopy];
}

- (id)initWithMat4:(Mat4)mat;
{
	return [self initWithMemory:(float*)&mat memoryResponsibility:Matrix4MemoryResponsibilityCopy];
}

- (void)dealloc;
{
	if (responsibility == Matrix4MemoryResponsibilityFree)
		free(v);
	
	[super dealloc];
}

+ (id)matrix;
{
	return [[[[self class] alloc] init] autorelease];
}

+ (id)matrixWithM11:(float)m11 m12:(float)m12 m13:(float)m13 m14:(float)m14
				m21:(float)m21 m22:(float)m22 m23:(float)m23 m24:(float)m24
				m31:(float)m31 m32:(float)m32 m33:(float)m33 m34:(float)m34
				m41:(float)m41 m42:(float)m42 m43:(float)m43 m44:(float)m44;
{
	return [[[[self class] alloc] initWithM11:m11 m12:m12 m13:m13 m14:m14
										  m21:m21 m22:m22 m23:m23 m24:m24
										  m31:m31 m32:m32 m33:m33 m34:m34
										  m41:m41 m42:m42 m43:m43 m44:m44] autorelease];
}

+ (id)matrixWithCArray:(float*)members;
{
	return [[[[self class] alloc] initWithCArray:members] autorelease];
}

+ (id)matrixWithMemory:(float*)members memoryResponsibility:(Matrix4MemoryResponsibility)responsibility_;
{
	return [[[[self class] alloc] initWithMemory:members memoryResponsibility:responsibility_] autorelease];
}

+ (id)matrixWithMatrix4:(Matrix4*)matrix;
{
	return [[[[self class] alloc] initWithMatrix4:matrix] autorelease];
}

+ (id)matrixWithMat4:(Mat4)mat;
{
	return [[[[self class] alloc] initWithMat4:mat] autorelease];
}

- (id)copyWithZone:(NSZone*)zone;
{
	return [self retain];
}

- (id)mutableCopyWithZone:(NSZone*)zone;
{
	return [[MutableMatrix4 alloc] initWithMatrix4:self];
}

- (float)element:(NSUInteger)element;
{
	return v[element];
}

- (float)elementAtRow:(NSUInteger)row column:(NSUInteger)column;
{
	NSParameterAssert(5 > row && 5 > column);
	return v[(column - 1) * 4 + row - 1];
}

- (const float*)elements;
{
	return v;
}

- (const float*)elementPtrToColumn:(NSUInteger)column;
{
	NSParameterAssert(5 > column);
	return &v[(column - 1) * 4];
}

- (const float*)elementPtrToColumn:(NSUInteger)column row:(NSUInteger)row;
{
	NSParameterAssert(5 > row && 5 > column);
	return &v[(column - 1) * 4 + row];
}

- (id)matrixByMultiplyingWithMatrix:(Matrix4*)rhs;
{
	float *members = malloc(sizeof (float) * 16);
	
	members[ 0] = M11 * rhs->M11 + M12 * rhs->M21 + M13 * rhs->M31 + M14 * rhs->M41;
	members[ 1] = M21 * rhs->M11 + M22 * rhs->M21 + M23 * rhs->M31 + M24 * rhs->M41;
	members[ 2] = M31 * rhs->M11 + M32 * rhs->M21 + M33 * rhs->M31 + M34 * rhs->M41;
	members[ 3] = M41 * rhs->M11 + M42 * rhs->M21 + M43 * rhs->M31 + M44 * rhs->M41;
	
	members[ 4] = M11 * rhs->M12 + M12 * rhs->M22 + M13 * rhs->M32 + M14 * rhs->M42;
	members[ 5] = M21 * rhs->M12 + M22 * rhs->M22 + M23 * rhs->M32 + M24 * rhs->M42;
	members[ 6] = M31 * rhs->M12 + M32 * rhs->M22 + M33 * rhs->M32 + M34 * rhs->M42;
	members[ 7] = M41 * rhs->M12 + M42 * rhs->M22 + M43 * rhs->M32 + M44 * rhs->M42;
	
	members[ 8] = M11 * rhs->M13 + M12 * rhs->M23 + M13 * rhs->M33 + M14 * rhs->M43;
	members[ 9] = M21 * rhs->M13 + M22 * rhs->M23 + M23 * rhs->M33 + M24 * rhs->M43;
	members[10] = M31 * rhs->M13 + M32 * rhs->M23 + M33 * rhs->M33 + M34 * rhs->M43;
	members[11] = M41 * rhs->M13 + M42 * rhs->M23 + M43 * rhs->M33 + M44 * rhs->M43;
	
	members[12] = M11 * rhs->M14 + M12 * rhs->M24 + M13 * rhs->M34 + M14 * rhs->M44;
	members[13] = M21 * rhs->M14 + M22 * rhs->M24 + M23 * rhs->M34 + M24 * rhs->M44;
	members[14] = M31 * rhs->M14 + M32 * rhs->M24 + M33 * rhs->M34 + M34 * rhs->M44;
	members[15] = M41 * rhs->M14 + M42 * rhs->M24 + M43 * rhs->M34 + M44 * rhs->M44;
	
	return [[self class] matrixWithMemory:members memoryResponsibility:Matrix4MemoryResponsibilityFree];
}

- (Vector4*)vectorByMultiplyingWithVector:(Vector4*)rhs;
{
	return [Vector4 vectorWithX:M11 * rhs.x + M12 * rhs.y + M13 * rhs.z + M14 * rhs.w
							  y:M21 * rhs.x + M22 * rhs.y + M23 * rhs.z + M24 * rhs.w
							  z:M31 * rhs.x + M32 * rhs.y + M33 * rhs.z + M34 * rhs.w
							  w:M41 * rhs.x + M42 * rhs.y + M43 * rhs.z + M44 * rhs.w];
}

- (NSString*)description;
{
	return [NSString stringWithFormat:@"(%.2f, %.2f, %.2f %.2f; %.2f, %.2f, %.2f %.2f; %.2f, %.2f, %.2f %.2f; %.2f, %.2f, %.2f %.2f)",
										 M11,  M12,  M13,  M14,
										 M21,  M22,  M23,  M24,
										 M31,  M32,  M33,  M34,
										 M41,  M42,  M43,  M44];
}

@end

@implementation MutableMatrix4

@end
