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

-(IBAction)uninstall:(id)sender
{
	NSAlert *alert = [NSAlert alertWithMessageText:@"Confirm" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Are you sure you wish to uninstall?"];
	[alert setShowsSuppressionButton:YES];
	[alert setAlertStyle:NSWarningAlertStyle];
	NSInteger alertReturn = [alert runModal];
}

-(IBAction)closeAdvancedSheet:(id)sender
{
	[NSApp endSheet:[self advancedPanel]];
}

@end
