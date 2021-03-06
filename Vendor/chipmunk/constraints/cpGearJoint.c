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
preStep(cpGearJoint *joint, cpFloat dt, cpFloat dt_inv)
{
	cpBody *a = joint->constraint.a;
	cpBody *b = joint->constraint.b;
	
	// calculate moment of inertia coefficient.
	joint->iSum = 1.0f/(a->i_inv*cpfabs(joint->ratio) + b->i_inv);
	
	// calculate bias velocity
	cpFloat maxBias = joint->constraint.maxBias;
	joint->bias = cpfclamp(-joint->constraint.biasCoef*dt_inv*(b->a*joint->ratio - a->a - joint->phase), -maxBias, maxBias);
	
	// compute max impulse
	joint->jMax = J_MAX(joint, dt);

	// apply joint torque
	a->w -= joint->jAcc*a->i_inv;
	b->w += joint->jAcc*b->i_inv*joint->ratio;
}

static void
applyImpulse(cpGearJoint *joint)
{
	cpBody *a = joint->constraint.a;
	cpBody *b = joint->constraint.b;
	
	// compute relative rotational velocity
	cpFloat wr = b->w*joint->ratio - a->w;
	
	// compute normal impulse	
	cpFloat j = (joint->bias - wr)*joint->iSum;
	cpFloat jOld = joint->jAcc;
	joint->jAcc = cpfclamp(jOld + j, -joint->jMax, joint->jMax);
	j = joint->jAcc - jOld;
	
	// apply impulse
	a->w -= j*a->i_inv;
	b->w += j*b->i_inv*joint->ratio;
}

static cpFloat
getImpulse(cpGearJoint *joint)
{
	return cpfabs(joint->jAcc);
}

const cpConstraintClass cpGearJointClass = {
	(cpConstraintPreStepFunction)preStep,
	(cpConstraintApplyImpulseFunction)applyImpulse,
	(cpConstraintGetImpulseFunction)getImpulse,
};

cpGearJoint *
cpGearJointAlloc(void)
{
	return (cpGearJoint *)malloc(sizeof(cpGearJoint));
}

cpGearJoint *
cpGearJointInit(cpGearJoint *joint, cpBody *a, cpBody *b, cpFloat phase, cpFloat ratio)
{
	cpConstraintInit((cpConstraint *)joint, &cpGearJointClass, a, b);
	
	joint->phase = phase;
	joint->ratio = ratio;
	
	joint->jAcc = 0.0f;
	
	return joint;
}

cpConstraint *
cpGearJointNew(cpBody *a, cpBody *b, cpFloat phase, cpFloat ratio)
{
	return (cpConstraint *)cpGearJointInit(cpGearJointAlloc(), a, b, phase, ratio);
}
