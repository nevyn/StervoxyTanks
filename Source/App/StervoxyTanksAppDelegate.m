//
//  StervoxyTanksAppDelegate.m
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-10.
//  Copyright Third Cog Software 2009. All rights reserved.
//

#import "StervoxyTanksAppDelegate.h"
#import "EAGLView.h"

@implementation StervoxyTanksAppDelegate

@synthesize window, nav;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[window addSubview:nav.view];
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)dealloc {
	[window release];
	[nav release];
	[super dealloc];
}

@end
