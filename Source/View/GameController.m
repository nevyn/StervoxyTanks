//
//  GameController.m
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-10.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import "GameController.h"
#import "Factory.h"

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
		
		[Factory entityFromArchetype:@"Tank"];
		
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
  CGPoint point = [[touches anyObject] locationInView:nil];
  //translate to -1 - 1, -1.5 - 1.5
  point.x = (point.x / gameView.bounds.size.width)*2 - 1;
  point.y = ((gameView.bounds.size.height-point.y) / gameView.bounds.size.height)*3 - 1.5;
  NSLog(@"Fiering @ %.3f %.3f", point.x, point.y);
  [gameView.level.playerTank shootAt:point];
}

@end
