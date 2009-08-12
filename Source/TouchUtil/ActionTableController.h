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

@interface TableAction : NSObject {
	NSString *name;
	ActionGroup *group;

}
@property (readonly, copy) NSString *name;
@property (readonly, assign) ActionGroup *group;
@end

@interface BlockAction : TableAction {
	ActionBlock block; 
}
+(BlockAction*)actionNamed:(NSString*)name block:(ActionBlock)block_;
-(id)initWithName:(NSString*)name block:(ActionBlock)block_;
@property (readonly, copy) ActionBlock block;
@end


@interface TargetAction : TableAction
{
	id target;
	SEL action;
}
@property (readonly, assign) id target;
@property (readonly, assign) SEL action;
+(TargetAction*)actionNamed:(NSString*)name target:(id)target_ action:(SEL)action_;
-(id)initWithName:(NSString*)name target:(id)target_ action:(SEL)action_;
@end

