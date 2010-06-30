//  PassengerController.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerController.h"

#import "AdvancedSheetController.h"
#import "AdvancedHostsController.h"
#import "ConfigurationController.h"
#import "HostsController.h"
#import "PassengerApacheController.h"
#import "PassengerApplication.h"
#import "SecurityHelper.h"

@implementation PassengerController

@synthesize sites, isAuthorized, hasSites, hasChanges, isConfigured;

#pragma mark -
#pragma mark Standard Overrides
-(id)init
{
	if (![super init])
		return nil;
	
	[self setHasSites:NO];
	[self setHasChanges:NO];
	[self setIsAuthorized:NO];
	[self setIsConfigured:NO];
	
	return self;
}

-(void)awakeFromNib
{
	g_passengerController = self;
	paneBundle = [NSBundle bundleWithIdentifier:PPCBundleID];
	
	[sitesTableView setAllowsMultipleSelection:YES];
	[sites setSelectsInsertedObjects:YES];
	
    [authView setString:kAuthorizationRightExecute];
	[authView setDelegate:self];
    [authView updateStatus:authView];
	[authView setAutoupdate:YES];
	
	[hasChangesImage setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
	[appHasChangesImage setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
	
	[configController checkConfiguration];
	
	if ([self isConfigured])
		[self loadSites];
}

#pragma mark -
#pragma mark Internal Methods

-(void)loadSites
{

}

-(AuthorizationRef)authRef
{
	return [[authView authorization] authorizationRef];
}

-(void)selectNameField:(NSTextField *)field
{
	[[field window] makeFirstResponder:field];
}


#pragma mark -
#pragma mark IBActions
-(IBAction)saveSite:(id)sender
{	
	for (PassengerApplication *site in [sites selectedObjects])
	{	
		if ([site authRef] == NULL)
			[site setAuthRef:[self authRef]];
		
		[[saveButton window] makeFirstResponder:saveButton];
		
		if ([site appIsActive])
			[HostsController createHost:[site address] withAuthRef:[self authRef]];
		else
			[HostsController removeHost:[site address] withAuthRef:[self authRef]];

		
		[site saveConfig];
	}
	[self setHasChanges:YES];
}

-(IBAction)addSite:(id)sender
{
	[sites add:sender];
	[self performSelector:@selector(selectNameField:) withObject:nameField afterDelay:0.25];
	[self setHasChanges:YES];
}

-(IBAction)removeSite:(id)sender
{
	for (PassengerApplication *site in [sites selectedObjects])
	{
		// Delete Conf file
		[site deleteConfig];
	}
	
	[sites remove:sender];
	[self setHasChanges:YES];
}

-(IBAction)openFileBrowser:(id)sender
{
	
}

-(IBAction)openSite:(id)sender
{
	
}

-(IBAction)restartApache:(id)sender
{
	[PassengerApacheController restartApache:[self authRef]];
	[self setHasChanges:NO];
}
-(IBAction)openConfigurationSheet:(id)sender
{
	[NSApp beginSheet:[configController configPanel] modalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
}

-(IBAction)openAdvancedSheet:(id)sender
{
	[[advancedController advancedHostsController] loadAllHosts];
	[NSApp beginSheet:[advancedController advancedPanel] modalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
}

-(IBAction)controlDidChange:(id)sender
{
	[self controlTextDidChange:nil];
}

#pragma mark -
#pragma mark SFAuthorizationView Delegate Methods
- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)view
{
	for (PassengerApplication *pa in [sites arrangedObjects])
		[pa setAuthRef:[self authRef]];
	
	[self setIsAuthorized:YES];
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view
{
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

#pragma mark -
#pragma mark Modal Delegate Methods for Advanced Sheet
- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
	for (PassengerApplication *pa in [sites selectedObjects])
		[pa setAppHasChanges:YES];
}

@end
