//
//  TCFakeAccelerometer.m
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-12.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import "TCFakeAccelerometer.h"

static TCFakeAccelerometer *fakeAccelerometer;

@interface UIAcceleration (Fake)
@property(nonatomic,readwrite) UIAccelerationValue x;
@property(nonatomic,readwrite) UIAccelerationValue y;
@property(nonatomic,readwrite) UIAccelerationValue z;
@property(nonatomic,readwrite) NSTimeInterval timestamp;

@end
@implementation UIAcceleration (Fake)
@dynamic x, y, z, timestamp;
@end



@implementation TCFakeAccelerometer
@synthesize delegate, updateInterval;
+(TCFakeAccelerometer*)sharedAccelerometer;
{
	if(!fakeAccelerometer)
		fakeAccelerometer = [[TCFakeAccelerometer alloc] init];
	return fakeAccelerometer;
}

-init;
{
	if( ! [super init] ) return nil;
	
	socket = [[AsyncSocket alloc] initWithDelegate:self];
	NSError *err = nil;
	[socket connectToHost:@"localhost" onPort:24638 error:&err];
	if(err)
		NSLog(@"TCFakeAccelerometer failed: %@", err.localizedDescription);
	[socket readDataToData:[AsyncSocket LFData] withTimeout:-1 tag:0];
	
	return self;
}
-(void)dealloc;
{
	[socket release];
	[super dealloc];
}


-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"Fake Socket connected");
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
{
	NSString *xyz = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];

	NSArray *xyza = [xyz componentsSeparatedByString:@"\t"];
	UIAcceleration *accel = [[[UIAcceleration alloc] init] autorelease];
	accel.x = -[[xyza objectAtIndex:0] doubleValue];
	accel.z = [[xyza objectAtIndex:1] doubleValue];
	accel.y = -[[xyza objectAtIndex:2] doubleValue];
	accel.timestamp = [NSDate timeIntervalSinceReferenceDate];
	
	[delegate accelerometer:(UIAccelerometer*)self didAccelerate:accel];
	
	[socket readDataToData:[AsyncSocket LFData] withTimeout:-1 tag:0];
}

@end
