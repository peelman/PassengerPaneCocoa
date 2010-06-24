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
	IBOutlet SFAuthorizationView *authView;
	
	BOOL *authorized;
	
}
@property (retain) NSArrayController *sites;

-(void)setupAuthorizationView;
-(IBAction)authorize:(id)sender;
-(IBAction)startApplication:(id)sender;
-(IBAction)stopApplication:(id)sender;
-(IBAction)restartApplication:(id)sender;

@end
