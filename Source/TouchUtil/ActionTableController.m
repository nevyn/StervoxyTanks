//
//  BlockActionTableController.m
//  BambSimpleViewer
//
//  Created by Joachim Bengtsson on 2009-07-26.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import "ActionTableController.h"

@interface ActionGroup ()
@property (readwrite, copy) NSString *name;
@property (readwrite, copy) NSArray *rows;
@end

@interface TableAction ()
@property (readwrite, copy) NSString *name;
@property (readwrite, assign) ActionGroup *group;
-(void)runFrom:(ActionTableController*)atc;
@end


@interface BlockAction ()
@property (readwrite, copy) ActionBlock block;
@end

@interface TargetAction ()
@property (readwrite, assign) id target;
@property (readwrite, assign) SEL action;
@end



@implementation ActionTableController
@dynamic tableView;
- (void)dealloc {
	self.hierarchy = nil;
	[super dealloc];
}
@synthesize hierarchy;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.hierarchy ? self.hierarchy.count : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self.hierarchy objectAtIndex:section] rows].count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
	ActionGroup *group = [self.hierarchy objectAtIndex:section];
	return group.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"BlockTableActionCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	ActionGroup *group = [self.hierarchy objectAtIndex:[indexPath indexAtPosition:0]];
	BlockAction *action = [[group rows] objectAtIndex:[indexPath indexAtPosition:1]];
	
	// Configure the cell.
	cell.textLabel.text = action.name;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

-(void)viewDidAppear:(BOOL)animated;
{
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}


 // Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	ActionGroup *group = [self.hierarchy objectAtIndex:[indexPath indexAtPosition:0]];
	TableAction *action = [[group rows] objectAtIndex:[indexPath indexAtPosition:1]];
	
	[action runFrom:self];
}


@end


@implementation ActionGroup
@synthesize name, rows;
+(ActionGroup*)groupNamed:(NSString*)name_ rows:(NSArray*)rows_;
{
	return [[[[self class] alloc] initWithName:name_ rows:rows_] autorelease];
}
-(id)initWithName:(NSString*)name_ rows:(NSArray*)rows_;
{
	if(![super init]) return nil;
	self.name = name_; self.rows = rows_;
	for (BlockAction *act in rows_)
		act.group = self;
	
	return self;
}
@end

@implementation TableAction
@synthesize name, group;
-(void)runFrom:(ActionTableController*)atc;
{

}
@end


@implementation BlockAction
@synthesize block;
+(BlockAction*)actionNamed:(NSString*)name_ block:(ActionBlock)block_;
{
	return [[[[self class] alloc] initWithName:name_ block:block_] autorelease];
}
-(id)initWithName:(NSString*)name_ block:(ActionBlock)block_;
{
	if(![super init]) return nil;
	self.name = name_; self.block = block_;
	return self;
}
-(void)runFrom:(ActionTableController*)atc;
{
	if(block)
		block(self, atc);
}
@end

@implementation TargetAction
@synthesize target, action;
+(TargetAction*)actionNamed:(NSString*)name_ target:(id)target_ action:(SEL)action_;
{
	return [[[[self class] alloc] initWithName:name_ target:target_ action:action_] autorelease];
}
-(id)initWithName:(NSString*)name_ target:(id)target_ action:(SEL)action_;
{
	if(! [super init] ) return nil;
	self.name = name_;
	self.target = target_;
	self.action = action_;
	return self;
}
-(void)runFrom:(ActionTableController*)atc;
{
	[target performSelector:action withObject:atc withObject:self];
}

@end