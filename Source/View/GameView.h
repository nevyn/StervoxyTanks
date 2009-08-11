//
//  GameView.h
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-10.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAGLView.h"

#import "Tank.h"
#import "Level.h"

@interface GameView : EAGLView {
  Tank *tank;
  Level *level;
}

@end
