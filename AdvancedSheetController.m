//  AdvancedSheetController.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "AdvancedSheetController.h"
#import "AdvancedHostsController.h"

@implementation AdvancedSheetController

@synthesize advancedHostsController, advancedPanel;

-(void)awakeFromNib
{
	[advancedHostsController loadAllHosts];
}

-(IBAction)closeAdvancedSheet:(id)sender
{
	[NSApp endSheet:[self advancedPanel]];
}

@end
