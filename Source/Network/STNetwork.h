//
//  STNetwork.h
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-12.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface STNetwork : NSObject <GKPeerPickerControllerDelegate> {
	BOOL server;
}
@property BOOL server;
@end
