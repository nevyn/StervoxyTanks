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


@interface BlockAction ()
@property (readwrite, copy) NSString *name;
@property (readwrite, copy) ActionBlock block;
@property (readwrite, assign) ActionGroup *group;
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
	BlockAction *action = [[group rows] objectAtIndex:[indexPath indexAtPosition:1]];
	
	if(action.block)
		action.block(action, self);
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


@implementation BlockAction
@synthesize name, block, group;
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
@end
