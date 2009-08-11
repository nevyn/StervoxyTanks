//
//  GameController.m
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-10.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import "GameController.h"


@implementation GameController
@synthesize gameView;
-(id)init;
{
	return [super initWithNibName:@"GameController" bundle:nil];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		gameView.animationInterval = 1./60.;
		[gameView startAnimation];
}

- (void)dealloc {
	NSLog(@"Dealloc game controller");
	self.gameView = nil;
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	self.gameView = nil;
}

-(void)viewDidDisappear:(BOOL)animated;
{
	[self.gameView stopAnimation];
}


@end
