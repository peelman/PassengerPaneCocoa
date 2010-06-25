//
//  PassengerController.m
//
//  Created by Nick Peelman on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PassengerController.h"
#import "PassengerApplication.h"

@implementation PassengerController

@synthesize sites, isAuthorized, hasSites, hasChanges;

-(id)init
{
	if (![super init])
		return nil;
	
	hasSites = hasChanges = isAuthorized = NO;
	
	return self;
}

-(void)awakeFromNib
{
	[sites setSelectsInsertedObjects:YES];
	[advancedAlertImage setHidden:YES];
    [authView setString:kAuthorizationRightExecute];
	[authView setDelegate:self];
    [authView updateStatus:authView];
	[authView setAutoupdate:YES];
}



-(IBAction)startApplications:(id)sender
{
	if (!isAuthorized)
		return;
	
	for (PassengerApplication *site in [sites selectedObjects])
	{	
		NSLog(@"Before Start: %i",[site appIsRunning]);
		[site startApplication];
		NSLog(@"After Start: %i",[site appIsRunning]);
	}
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
	[self setIsAuthorized:YES];
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view
{
	[self setIsAuthorized:NO];
}



@end
