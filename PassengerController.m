//
//  PassengerController.m
//
//  Created by Nick Peelman on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PassengerController.h"
#import "PassengerApplication.h"

@implementation PassengerController

@synthesize sites, hasSites, hasChanges;

-(id)init
{
	if (![super init])
		return nil;
	
	hasSites = hasChanges = authorized = NO;
	
	return self;
}

-(void)awakeFromNib
{
	[advancedAlertImage setHidden:YES];
	[self setupAuthorizationView];
	[sites setSelectsInsertedObjects:YES];
}

-(void)setupAuthorizationView
{
    authorized = NO;
    [authView setString:kAuthorizationRightExecute];
    [authView setDelegate:self];
    [authView updateStatus:self];
	[authView setAutoupdate:YES];
}

-(IBAction)authorize:(id)sender
{
	AuthorizationFlags authFlags = kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights | kAuthorizationFlagInteractionAllowed;
	[[authView authorization] obtainWithRight:kAuthorizationRightExecute flags:authFlags error:nil];
//	AuthorizationRef myAuthorizationRef;
//	AuthorizationFlags authFlags = kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights | kAuthorizationFlagInteractionAllowed;
//
//	OSStatus myStatus;
//	myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, authFlags, &myAuthorizationRef);


}

-(IBAction)startApplications:(id)sender
{
	for (PassengerApplication *site in [sites selectedObjects])
		[site startApplication];
}

-(IBAction)stopApplications:(id)sender
{
	for (PassengerApplication *site in [sites selectedObjects])
		[site stopApplication];
}

-(IBAction)restartApplications:(id)sender
{
	for (PassengerApplication *site in [sites selectedObjects])
		[site restartApplication];
}


- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)view
{
	
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view
{
	
}



@end
