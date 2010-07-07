//  PassengerController.h
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import <Cocoa/Cocoa.h>
#import <SecurityInterface/SFAuthorizationView.h>
#import <OpenDirectory/OpenDirectory.h>

#import "PassengerShared.h"

@class AdvancedSheetController;
@class ConfigurationController;

@interface PassengerController : NSObject 
{
	IBOutlet NSWindow *prefsWindow;
	IBOutlet NSView *prefsView;
	IBOutlet NSArrayController *sites;
	IBOutlet NSTableView *sitesTableView;
	IBOutlet SFAuthorizationView *authView;
	
	IBOutlet NSButton *saveButton;
	IBOutlet NSButton *enabledCheckbox;
	IBOutlet NSButton *browseButton;
	IBOutlet NSButton *openSiteButton;
	IBOutlet NSButton *addSiteButton;
	IBOutlet NSButton *removeSiteButton;
	IBOutlet NSButton *helpButton;
	IBOutlet NSButton *advancedButton;
	IBOutlet NSButton *configureButton;
	
	IBOutlet NSTextField *nameField;
	IBOutlet NSTextField *addressField;
	IBOutlet NSTextField *portField;
	IBOutlet NSTextField *folderField;
	IBOutlet NSTextField *tableViewOverlay;
	IBOutlet NSTextField *statusText;

	IBOutlet NSImageView *statusImage;
	IBOutlet NSImageView *hasChangesImage;
	IBOutlet NSImageView *appHasChangesImage;

	IBOutlet NSMatrix *modeMatrix;
	
	IBOutlet AdvancedSheetController *advancedController;
	IBOutlet ConfigurationController *configController;
	
	BOOL isAuthorized, hasSites, hasChanges, isConfigured;
	
}
@property (retain) NSArrayController *sites;
@property BOOL isAuthorized, hasSites, hasChanges, isConfigured;

-(void)loadSites;

-(AuthorizationRef)authRef;
-(void)selectNameField:(NSTextField *)field;

-(IBAction)saveSite:(id)sender;
-(IBAction)addSite:(id)sender;
-(IBAction)removeSite:(id)sender;
-(IBAction)openFileBrowser:(id)sender;
-(IBAction)openSite:(id)sender;
-(IBAction)restartApache:(id)sender;
-(IBAction)openAdvancedSheet:(id)sender;
-(IBAction)openConfigurationSheet:(id)sender;
-(IBAction)controlDidChange:(id)sender;

- (void)fileBrowserClosed:(NSOpenPanel *)openPanel returnCode:(int)code contextInfo:(void *)info;

@end
