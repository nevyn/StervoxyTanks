//
//  STNetwork.m
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-12.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import "STNetwork.h"


@implementation STNetwork
@synthesize server;

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
	GKSession* session = [[GKSession alloc] initWithSessionID:nil
																								displayName:nil
																								sessionMode:self.server ? GKSessionModeServer : GKSessionModeClient];
	[session autorelease];
	return session;
}

@end
