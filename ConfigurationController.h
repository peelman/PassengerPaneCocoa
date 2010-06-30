//  ConfigurationController.h
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import <Cocoa/Cocoa.h>

#import "PassengerShared.h"

@interface ConfigurationController : NSObject 
{

	IBOutlet NSPanel *configPanel;
	
	IBOutlet NSTextField *statusText;
	
	IBOutlet NSButton *autoConfigButton;
	IBOutlet NSButton *closeConfigurationButton;

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
	
	NSString *sitesPath, *rubyPath, *passengerPath, *apacheModPath, *apacheConfigPath;
	
	BOOL sitesDirectoryFound, rubyFound, passengerFound, passengerLinked, apacheModFound, apacheConfigured;
}

@property (readonly) NSPanel *configPanel;
@property BOOL sitesDirectoryFound, rubyFound, passengerFound, passengerLinked, apacheModFound, apacheConfigured;

-(void)checkConfiguration;
-(void)configureApacheSites;
-(void)configurePassenger;
-(void)configureApache;
-(void)installPassenger;
-(void)createPassengerSymLink;
-(void)installPassengerApacheMod;

-(IBAction)attemptConfiguration:(id)sender;
-(IBAction)closeConfigurationSheet:(id)sender;

@end
