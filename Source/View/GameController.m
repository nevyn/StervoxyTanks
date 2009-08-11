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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	self.gameView = nil;
}

- (void)viewDidAppear:(BOOL)animated;
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidDissapear:(BOOL)animated;
{
	[self.gameView stopAnimation];
	self.navigationController.navigationBarHidden = NO;
}

@end
