//  AdvancedSheetController.h
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import <Cocoa/Cocoa.h>

#import "PassengerShared.h"

@class AdvancedHostsController;

@interface AdvancedSheetController : NSObject {
	
	IBOutlet AdvancedHostsController *advancedHostsController;
	IBOutlet NSPanel *advancedPanel;
	IBOutlet NSButton *advancedUninstallButton;
	IBOutlet NSButton *advancedUpdatePassengerButton;
	IBOutlet NSButton *advancedReLinkPassengerButton;
	IBOutlet NSButton *advancedCloseButton;
}
@property (readonly) AdvancedHostsController *advancedHostsController;
@property (readonly) NSPanel *advancedPanel;
@end
