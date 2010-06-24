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
	
	hasSites = hasChanges = NO;
	
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
//    [authView setStringValue:kAuthorizationRightExecute]
//    [authView setDelegate:self];
//    [authView updateStatus:NO];
//	[authView setAutoUpdate:YES];
}

-(IBAction)authorize:(id)sender
{
	//kAuthorizationRightExecute (kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights | kAuthorizationFlagInteractionAllowed)

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

@end
