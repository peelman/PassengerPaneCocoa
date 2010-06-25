//
//  PassengerController.h
//
//  Created by Nick Peelman on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SecurityInterface/SFAuthorizationView.h>


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
	IBOutlet NSButton *addSiteButton;
	IBOutlet NSButton *removeSiteButton;
	IBOutlet NSButton *helpButton;
	
	IBOutlet NSTextField *addressField;
	IBOutlet NSTextField *folderField;
	
	IBOutlet NSMatrix *modeMatrix;
	
	
	BOOL isAuthorized;
	BOOL hasSites;
	BOOL hasChanges;
	
}
@property (retain) NSArrayController *sites;
@property BOOL isAuthorized, hasSites, hasChanges;


-(IBAction)startApplications:(id)sender;
-(IBAction)stopApplications:(id)sender;
-(IBAction)restartApplications:(id)sender;

@end
