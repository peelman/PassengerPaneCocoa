//  PassengerController.h
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import <Cocoa/Cocoa.h>
#import <SecurityInterface/SFAuthorizationView.h>
#import <OpenDirectory/OpenDirectory.h>

#import "PassengerShared.h"

@class AdvancedHostsController;

@interface PassengerController : NSObject 
{
	IBOutlet NSWindow *prefsWindow;
	IBOutlet NSPanel *advancedView;
	IBOutlet NSView *prefsView;
	IBOutlet NSArrayController *sites;
	IBOutlet NSTableView *sitesTableView;
	IBOutlet SFAuthorizationView *authView;
	
	IBOutlet AdvancedHostsController *advancedHostsController;
	
	IBOutlet NSButton *startButton;
	IBOutlet NSButton *stopButton;
	IBOutlet NSButton *restartButton;
	IBOutlet NSButton *browseButton;
	IBOutlet NSButton *openSiteButton;
	IBOutlet NSButton *addSiteButton;
	IBOutlet NSButton *removeSiteButton;
	IBOutlet NSButton *helpButton;
	IBOutlet NSButton *advancedButton;
	IBOutlet NSButton *configureButton;
	IBOutlet NSButton *advancedUpdatePassengerButton;
	IBOutlet NSButton *advancedReLinkPassengerButton;
	IBOutlet NSButton *advancedCloseButton;
	IBOutlet NSButton *advancedHostsRemoveButton;
	
	IBOutlet NSTextField *nameField;
	IBOutlet NSTextField *addressField;
	IBOutlet NSTextField *portField;
	IBOutlet NSTextField *folderField;
	IBOutlet NSTextField *tableViewOverlay;
	IBOutlet NSTextField *statusText;

	IBOutlet NSImageView *statusImage;
	IBOutlet NSImageView *hasChangesImage;
	IBOutlet NSMatrix *modeMatrix;
	
	
	BOOL isAuthorized, hasSites, hasChanges, isConfigured;
	NSBundle *paneBundle;
	
}
@property (retain) NSArrayController *sites;
@property BOOL isAuthorized, hasSites, hasChanges, isConfigured;

-(void)checkConfiguration;
-(void)loadSites;
-(void)configureApacheSites;
-(void)configurePassenger;
-(void)configureApache;
-(void)installPassenger;
-(void)createPassengerSymLink;
-(void)installPassengerApacheMod;

-(AuthorizationRef)authRef;
-(void)selectNameField:(NSTextField *)field;

-(IBAction)loadApplication:(id)sender;
-(IBAction)unloadApplication:(id)sender;
-(IBAction)reloadApplication:(id)sender;

-(IBAction)addSite:(id)sender;
-(IBAction)removeSite:(id)sender;
-(IBAction)openFileBrowser:(id)sender;
-(IBAction)openSite:(id)sender;
-(IBAction)attemptConfiguration:(id)sender;
-(IBAction)restartApache:(id)sender;
-(IBAction)openAdvancedSheet:(id)sender;
-(IBAction)closeAdvancedSheet:(id)sender;
@end
