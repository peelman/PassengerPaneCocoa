//
//  PassengerController.m
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
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


#pragma mark -
#pragma mark IBActions
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

-(IBAction)addSite:(id)sender
{
	[sites add:sender];

	[self performSelector:@selector(selectNameField:) withObject:nameField afterDelay:0.25];
}
	 
 -(void)selectNameField:(NSTextField *)field
 {
	 [[field window] makeFirstResponder:field];
 }

-(IBAction)openFileBrowser:(id)sender
{
	
}

-(IBAction)openSite:(id)sender
{
	
}

#pragma mark -
#pragma mark SFAuthorizationView Delegate Methods
- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)view
{
	[self setIsAuthorized:YES];
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view
{
	[self setIsAuthorized:NO];
}



@end
