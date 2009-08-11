//
//  MainMenu.m
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-10.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import "MainMenu.h"
#import "CollectionUtils.h"
#import "GameController.h"

@implementation MainMenu
-(id)init;
{
	return [super initWithNibName:@"MainMenu" bundle:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Main menu";
	
	self.hierarchy = $array(
		[ActionGroup groupNamed:nil rows:$array(
			[BlockAction actionNamed:@"Singleplayer" block:^(BlockAction *w, ActionTableController *c) {
				[c.navigationController pushViewController:[[GameController new] autorelease] animated:YES];
			}],
			[BlockAction actionNamed:@"Multiplayer" block:^(BlockAction *w, ActionTableController *c) {
				NSLog(@"Woah");
			}]
		)]
	);

}

- (void)dealloc {
    [super dealloc];
}


@end
