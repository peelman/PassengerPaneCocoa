//  AdvancedHostsController.h
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import <Cocoa/Cocoa.h>

#import "PassengerApplication.h"
#import "PassengerShared.h"

@class PassengerController;

@interface AdvancedHostsController : NSObject 
{	
	IBOutlet PassengerController *controller;
	IBOutlet NSArrayController *hostsArray;
	IBOutlet NSTableView *advancedHostsTableView;
	IBOutlet NSButton *reloadHostsButton;
	IBOutlet NSButton *removeSelectedHostButton;
}

-(void)loadAllHosts;

-(IBAction)removeSelectedHost:(id)sender;
-(IBAction)reloadHosts:(id)sender;

@end
