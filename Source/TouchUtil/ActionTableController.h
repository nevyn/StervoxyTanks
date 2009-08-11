//
//  BlockActionTableController.h
//  BambSimpleViewer
//
//  Created by Joachim Bengtsson on 2009-07-26.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionTableController : UITableViewController {
	NSArray *hierarchy;
}
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property (copy) NSArray *hierarchy;

@end

@interface ActionGroup : NSObject {
	NSString *name;
	NSArray *rows;
}
+(ActionGroup*)groupNamed:(NSString*)name rows:(NSArray*)rows_;
-(id)initWithName:(NSString*)name rows:(NSArray*)rows_;
@property (readonly, copy) NSString *name;
@property (readonly, copy) NSArray *rows;
@end


@class BlockAction;
typedef void(^ActionBlock)(BlockAction *what, ActionTableController *controller);


@interface BlockAction : NSObject {
	NSString *name;
	ActionBlock block; 
	ActionGroup *group;
}
+(BlockAction*)actionNamed:(NSString*)name block:(ActionBlock)block_;
-(id)initWithName:(NSString*)name block:(ActionBlock)block_;
@property (readonly, copy) NSString *name;
@property (readonly, copy) ActionBlock block;
@property (readonly, assign) ActionGroup *group;
@end
