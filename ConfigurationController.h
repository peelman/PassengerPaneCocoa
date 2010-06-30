//
//  ConfigurationController.h
//
//  Created by Nick Peelman on 6/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PassengerShared.h"

@interface ConfigurationController : NSObject 
{

	IBOutlet NSPanel *configPanel;
	IBOutlet NSButton *autoConfigButton;

	IBOutlet NSButton *sitesDirectoryCheckbox;
	IBOutlet NSButton *rubyCheckbox;
	IBOutlet NSButton *passengerCheckbox;
	IBOutlet NSButton *passengerLinkedCheckbox;
	IBOutlet NSButton *passengerApacheModCheckbox;
	IBOutlet NSButton *passengerApacheConfigCheckbox;
	
	IBOutlet NSPathControl *sitesDirectoryPathControl;
	IBOutlet NSPathControl *rubyPathControl;
	IBOutlet NSPathControl *passengerPathControl;
	IBOutlet NSPathControl *passengerApacheModPathControl;
	IBOutlet NSPathControl *passengerApacheConfigPathControl;
}

@property (readonly) NSPanel *configPanel;

@end
