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
#import	"STNetwork.h"

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
			[BlockAction actionNamed:@"Single player" block:^(BlockAction *w, ActionTableController *c) {
				[c.navigationController pushViewController:[[GameController new] autorelease] animated:YES];
			}],
			[TargetAction actionNamed:@"Host game" target:self action:@selector(multiplayer::)],
			[TargetAction actionNamed:@"Join game" target:self action:@selector(multiplayer::)]
		)]
	);
}

- (void)dealloc {
    [super dealloc];
}

-(IBAction)multiplayer:(id)sender :(TargetAction*)action;
{
	GKPeerPickerController *picker = [GKPeerPickerController new];
	STNetwork *net = [STNetwork new];
	if([action.name hasPrefix:@"Host"])
		net.server = YES;
	
	picker.delegate = net;
	picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby | GKPeerPickerConnectionTypeOnline;
	[picker show];
}


@end
