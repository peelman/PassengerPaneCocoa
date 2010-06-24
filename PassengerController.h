//
//  PassengerController.h
//
//  Created by Nick Peelman on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Security/AuthorizationTags.h>
#import "SecurityHelper.h"


@interface PassengerController : NSObject {

	IBOutlet NSArrayController *sites;
	IBOutlet NSTableView *sitesTableView;
//	IBOutlet SFAuthorizationView *authView;
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
	
	
	BOOL *authorized;
	
}
@property (retain) NSArrayController *sites;

-(void)setupAuthorizationView;
-(IBAction)authorize:(id)sender;
-(IBAction)startApplications:(id)sender;
-(IBAction)stopApplications:(id)sender;
-(IBAction)restartApplications:(id)sender;

@end
