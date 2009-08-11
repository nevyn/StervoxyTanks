//
//  GameController.h
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-10.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"

@interface GameController : UIViewController {
	GameView *gameView;
}
@property (nonatomic, retain) IBOutlet GameView *gameView;
@end
