//
//  PassengerController.h
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//
#import <Cocoa/Cocoa.h>
#import <SecurityInterface/SFAuthorizationView.h>

#import "PassengerShared.h"

@interface PassengerController : NSObject {

	IBOutlet NSWindow *prefsWindow;
	IBOutlet NSView *prefsView;
	IBOutlet NSWindow *advancedPanel;
	IBOutlet NSArrayController *sites;
	IBOutlet NSTableView *sitesTableView;
	IBOutlet SFAuthorizationView *authView;
	IBOutlet NSImageView *advancedAlertImage;
	IBOutlet NSButton *advancedButton;
	
	IBOutlet NSButton *startButton;
	IBOutlet NSButton *stopButton;
	IBOutlet NSButton *restartButton;
	IBOutlet NSButton *browseButton;
	IBOutlet NSButton *openSiteButton;
	IBOutlet NSButton *addSiteButton;
	IBOutlet NSButton *removeSiteButton;
	IBOutlet NSButton *helpButton;
	
	IBOutlet NSTextField *nameField;
	IBOutlet NSTextField *addressField;
	IBOutlet NSTextField *portField;
	IBOutlet NSTextField *folderField;
	IBOutlet NSTextField *tableViewOverlay;
	IBOutlet NSTextField *statusText;
	
	IBOutlet NSMatrix *modeMatrix;
	
	
	BOOL isAuthorized, hasSites, hasChanges, isConfigured;
	
}
@property (retain) NSArrayController *sites;
@property BOOL isAuthorized, hasSites, hasChanges, isConfigured;

-(void)checkConfiguration;
-(void)loadSites;

-(IBAction)startApplications:(id)sender;
-(IBAction)stopApplications:(id)sender;
-(IBAction)restartApplications:(id)sender;

-(IBAction)addSite:(id)sender;
-(IBAction)removeSite:(id)sender;
-(IBAction)openFileBrowser:(id)sender;
-(IBAction)openSite:(id)sender;

@end
