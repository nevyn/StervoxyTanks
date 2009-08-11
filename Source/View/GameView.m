//
//  GameView.m
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-10.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import "GameView.h"

@implementation GameView


-(id)commonInit;
{
  [super commonInit];
  [CPChipmunk initChipmunk];

  level = [[Level alloc] init];
  
  return self;
}

- (void)draw;
{
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);

  [level update];
  [level draw];
}

@end
