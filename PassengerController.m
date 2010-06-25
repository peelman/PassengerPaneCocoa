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
	[sitesTableView setAllowsMultipleSelection:YES];
	[sites setSelectsInsertedObjects:YES];
	[advancedAlertImage setHidden:YES];
	
    [authView setString:kAuthorizationRightExecute];
	[authView setDelegate:self];
    [authView updateStatus:authView];
	[authView setAutoupdate:YES];
}

-(void)selectNameField:(NSTextField *)field
{
	[[field window] makeFirstResponder:field];
}

#pragma mark -
#pragma mark IBActions
-(IBAction)startApplications:(id)sender
{
	if (!isAuthorized)
		return;
	
	for (PassengerApplication *site in [sites selectedObjects])
	{	
		if ([site authRef] == NULL)
			[site setAuthRef:[[authView authorization] authorizationRef]];
		
		[site startApplication];
	}
}

-(IBAction)stopApplications:(id)sender
{
	for (PassengerApplication *site in [sites selectedObjects])
	{	
		if ([site authRef] == NULL)
			[site setAuthRef:[[authView authorization] authorizationRef]];
		
		[site stopApplication];
	}
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

-(IBAction)removeSite:(id)sender
{
	NSLog(@"Removing Selected Sites");
	for (PassengerApplication *site in [sites selectedObjects])
	{	
		if ([site appIsRunning])
			[site stopApplication];
	}
	
	[sites remove:sender];
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
	NSLog(@"AuthView Did Authorize");
	for (PassengerApplication *pa in [sites arrangedObjects])
		[pa setAuthRef:[[authView authorization] authorizationRef]];
	
	[self setIsAuthorized:YES];
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view
{
	NSLog(@"AuthView Did Deauthorize");
	for (PassengerApplication *pa in [sites arrangedObjects])
		[pa setAuthRef:NULL];
	
	[self setIsAuthorized:NO];
}

#pragma mark -
#pragma mark TableView Delegate

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	if ([[sites arrangedObjects] count] == 0)
		[tableViewOverlay setHidden:NO];
	else
		[tableViewOverlay setHidden:YES];
}

@end
