/* Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <stdlib.h>

#include "../chipmunk.h"
#include "util.h"

static void
preStep(cpSlideJoint *joint, cpFloat dt, cpFloat dt_inv)
{
	cpBody *a = joint->constraint.a;
	cpBody *b = joint->constraint.b;
	
	joint->r1 = cpvrotate(joint->anchr1, a->rot);
	joint->r2 = cpvrotate(joint->anchr2, b->rot);
	
	cpVect delta = cpvsub(cpvadd(b->p, joint->r2), cpvadd(a->p, joint->r1));
	cpFloat dist = cpvlength(delta);
	cpFloat pdist = 0.0;
	if(dist > joint->max) {
		pdist = dist - joint->max;
	} else if(dist < joint->min) {
		pdist = joint->min - dist;
		dist = -dist;
	}
	joint->n = cpvmult(delta, 1.0f/(dist ? dist : INFINITY));
	
	// calculate mass normal
	joint->nMass = 1.0f/k_scalar(a, b, joint->r1, joint->r2, joint->n);
	
	// calculate bias velocity
	cpFloat maxBias = joint->constraint.maxBias;
	joint->bias = cpfclamp(-joint->constraint.biasCoef*dt_inv*(pdist), -maxBias, maxBias);
	
	// compute max impulse
	joint->jnMax = J_MAX(joint, dt);

	// apply accumulated impulse
	if(!joint->bias) //{
		// if bias is 0, then the joint is not at a limit.
		joint->jnAcc = 0.0f;
//	} else {
		cpVect j = cpvmult(joint->n, joint->jnAcc);
		apply_impulses(a, b, joint->r1, joint->r2, j);
//	}
}

static void
applyImpulse(cpSlideJoint *joint)
{
	if(!joint->bias) return;  // early exit

	cpBody *a = joint->constraint.a;
	cpBody *b = joint->constraint.b;
	
	cpVect n = joint->n;
	cpVect r1 = joint->r1;
	cpVect r2 = joint->r2;
		
	// compute relative velocity
	cpVect vr = relative_velocity(a, b, r1, r2);
	cpFloat vrn = cpvdot(vr, n);
	
	// compute normal impulse
	cpFloat jn = (joint->bias - vrn)*joint->nMass;
	cpFloat jnOld = joint->jnAcc;
	joint->jnAcc = cpfclamp(jnOld + jn, -joint->jnMax, 0.0f);
	jn = joint->jnAcc - jnOld;
	
	// apply impulse
	apply_impulses(a, b, joint->r1, joint->r2, cpvmult(n, jn));
}

static cpFloat
getImpulse(cpConstraint *joint)
{
	return cpfabs(((cpSlideJoint *)joint)->jnAcc);
}

const cpConstraintClass cpSlideJointClass = {
	(cpConstraintPreStepFunction)preStep,
	(cpConstraintApplyImpulseFunction)applyImpulse,
	(cpConstraintGetImpulseFunction)getImpulse,
};

cpSlideJoint *
cpSlideJointAlloc(void)
{
	return (cpSlideJoint *)malloc(sizeof(cpSlideJoint));
}

cpSlideJoint *
cpSlideJointInit(cpSlideJoint *joint, cpBody *a, cpBody *b, cpVect anchr1, cpVect anchr2, cpFloat min, cpFloat max)
{
	cpConstraintInit((cpConstraint *)joint, &cpSlideJointClass, a, b);
	
	joint->anchr1 = anchr1;
	joint->anchr2 = anchr2;
	joint->min = min;
	joint->max = max;
	
	joint->jnAcc = 0.0;
	
	return joint;
}

cpConstraint *
cpSlideJointNew(cpBody *a, cpBody *b, cpVect anchr1, cpVect anchr2, cpFloat min, cpFloat max)
{
	return (cpConstraint *)cpSlideJointInit(cpSlideJointAlloc(), a, b, anchr1, anchr2, min, max);
}
