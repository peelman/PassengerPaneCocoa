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
		
	NSString *sitesPath, *rubyPath, *passengerPath, *apacheModPath, *apacheConfigPath;
	
	BOOL sitesPathFound, rubyFound, passengerFound, passengerLinked, apacheModFound, apacheConfigured;
}

@property (readonly) NSPanel *configPanel;
@property (copy) NSString *sitesPath, *rubyPath, *passengerPath, *apacheModPath, *apacheConfigPath;
@property BOOL sitesPathFound, rubyFound, passengerFound, passengerLinked, apacheModFound, apacheConfigured;

-(BOOL)checkSitesDirectoryConfig;
-(BOOL)checkRubyConfig;
-(BOOL)checkPassengerConfig;
-(BOOL)checkPassengerLinked;
-(BOOL)checkApacheMod;
-(BOOL)checkApacheConfig;


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
