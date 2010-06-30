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
-(void)checkConfiguration
{
	// Locate Config Dir
	NSFileManager *fm = [NSFileManager defaultManager];

	BOOL isDir = NO;	
	if (![fm fileExistsAtPath:SitesConfDir isDirectory:&isDir] || !isDir)
	{
		[statusText setStringValue:@"Config Directory Doesn't Exist"];
		[statusImage setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
		NSLog(@"%@",[statusText stringValue]);
		[self setIsConfigured:NO];
		return;
	}
	
	// Locate Ruby
	if (![fm fileExistsAtPath:RubyLocation])
	{
		[statusText setStringValue:@"Ruby Not Found"];
		[statusImage setImage:[NSImage imageNamed:NSImageNameStatusPartiallyAvailable]];
		NSLog(@"%@",[statusText stringValue]);
		[self setIsConfigured:NO];
		return;
	}

	// Locate Passenger
	if (![fm fileExistsAtPath:PassengerConfigTool])
	{
		[statusText setStringValue:@"Passenger Not Found"];
		[statusImage setImage:[NSImage imageNamed:NSImageNameStatusPartiallyAvailable]];
		NSLog(@"%@",[statusText stringValue]);
		[self setIsConfigured:NO];
		return;
	}
	
	// Locate Passsenger Link
	if (![fm fileExistsAtPath:PassengerCurrentVersDir isDirectory:&isDir] || !isDir)
	{
		[statusText setStringValue:@"Passenger Not Linked"];
		[statusImage setImage:[NSImage imageNamed:NSImageNameStatusPartiallyAvailable]];
		NSLog(@"%@", [statusText stringValue]);
		[self setIsConfigured:NO];
		return;
	}
	
	// Locate Passenger Apache Module
	if (![fm fileExistsAtPath:PassengerModuleLocation])
	{
		[statusText setStringValue:@"Passenger Apache Module Not Found"];
		[statusImage setImage:[NSImage imageNamed:NSImageNameStatusPartiallyAvailable]];
		NSLog(@"%@",[statusText stringValue]);
		[self setIsConfigured:NO];
		return;
	}
	
	// Locate Passenger Apache Config File
	if (![fm fileExistsAtPath:[NSString stringWithFormat:@"%@%@.%@",ApacheConfDir, PPCApacheConfigFile, ConfExtension]])
	{
		[statusText setStringValue:@"Apache Not Configured to run Passenger"];
		[statusImage setImage:[NSImage imageNamed:NSImageNameStatusPartiallyAvailable]];
		NSLog(@"%@",[statusText stringValue]);
		[self setIsConfigured:NO];
		return;
	}
	
	[statusText setStringValue:@""];
	[self setIsConfigured:YES];
}

-(void)loadSites
{

}

-(void)configureApacheSites
{
	[statusText setStringValue:@"Configuring Apache Sites..."];
	NSLog(@"%@", [statusText stringValue]);
	NSFileManager *fm = [[NSFileManager alloc] init];
	BOOL isDir = NO;	
	
	if (![fm fileExistsAtPath:SitesConfDir isDirectory:&isDir] || !isDir)
	{
		NSArray *args = [NSArray arrayWithObjects:SitesConfDir, nil];
		
		SecurityHelper *sh = [SecurityHelper sharedInstance];
		[sh setAuthorizationRef:[self authRef]];
		[sh executeCommand:MkdirLocation withArgs:args];
	}
	
	[fm release];
}

-(void)configurePassenger
{
	[statusText setStringValue:@"Configuring Passenger..."];
	NSLog(@"%@", [statusText stringValue]);	
	NSFileManager *fm = [[NSFileManager alloc] init];
	
	if (![fm fileExistsAtPath:PassengerConfigTool]) 
	{
		[statusText setStringValue:@"Attempting to install Passenger..."];
		NSLog(@"%@", [statusText stringValue]);
		[self installPassenger];
	}
	
	BOOL isDir = NO;
	if (![fm fileExistsAtPath:PassengerCurrentVersDir isDirectory:&isDir] || !isDir)
	{
		[statusText setStringValue:@"Linking Current Version..."];
		NSLog(@"%@", [statusText stringValue]);
		[self createPassengerSymLink];
	}
	
	if (![fm fileExistsAtPath:PassengerModuleLocation])
	{
		[statusText setStringValue:@"Attempting to install Passenger Module..."];
		NSLog(@"%@", [statusText stringValue]);
		[self installPassengerApacheMod];
	}
	
	[fm release];
}

-(void)configureApache
{
	[statusText setStringValue:@"Configuring Apache..."];
	NSLog(@"%@", [statusText stringValue]);
	
	NSFileManager *fm = [[NSFileManager alloc] init];
	NSString *confFilePath = [paneBundle pathForResource:PPCApacheConfigFile ofType:ConfExtension];

	if (![fm fileExistsAtPath:[NSString stringWithFormat:@"%@%@",ApacheConfDir,PPCApacheConfigFile]])
	{
		NSArray *args = [NSArray arrayWithObjects:confFilePath, ApacheConfDir, nil];
		SecurityHelper *sh = [SecurityHelper sharedInstance];
		[sh setAuthorizationRef:[self authRef]];
		[sh executeCommand:CpLocation withArgs:args];
	}
		 
	[fm release];
}

-(void)installPassenger
{
	[statusText setStringValue:@"Installing Passenger...please wait!"];
	NSLog(@"%@", [statusText stringValue]);
	
	NSAlert *alert = [NSAlert alertWithMessageText:@"Warning!"
									 defaultButton:@"OK"
								   alternateButton:nil
									   otherButton:nil 
						 informativeTextWithFormat:@"Installing Passenger can take a few minutes. System Preferences may become unresponsive (spinning beach ball of doom) during this time.  This is normal! However, if the process lasts longer than a few minutes, you may need to Force Quit System Prefences"];
	[alert setIcon:[NSImage imageNamed:NSImageNameInfo]];
	[alert runModal];
	
	NSString *passengerInstaller = [paneBundle pathForResource:PPCInstallPassengerPackageName ofType:PkgExtension];

	NSArray *args = [NSArray arrayWithObjects:@"-pkg", passengerInstaller, @"-target", @"/", nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:[self authRef]];
	[sh executeCommand:InstallerLocation withArgs:args];
}
	
-(void)createPassengerSymLink
{
	NSString *passengerLinkScript = [paneBundle pathForResource:PPCCreateLinkScriptName ofType:ShellScriptExtension];

	NSArray *args = [NSArray arrayWithObjects:passengerLinkScript, nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:[self authRef]];
	[sh executeCommand:BashLocation withArgs:args];
}

-(void)installPassengerApacheMod
{
	[statusText setStringValue:@"Installing Passenger Module...please wait!"];
	NSLog(@"%@", [statusText stringValue]);
	
	NSAlert *alert = [NSAlert alertWithMessageText:@"Warning!"
									 defaultButton:@"OK"
								   alternateButton:nil
									   otherButton:nil 
						 informativeTextWithFormat:@"Installing the Apache Module for Passenger can take a few minutes. System Preferences may become unresponsive (spinning beach ball of doom) during this time.  This is normal! However, if the process lasts longer than a few minutes, you may need to Force Quit System Preferences"];
	[alert setIcon:[NSImage imageNamed:NSImageNameInfo]];
	[alert runModal];
	
	NSString *modInstaller = [paneBundle pathForResource:PPCInstallPassengerApacheModPackageName ofType:PkgExtension];
	
	NSArray *args = [NSArray arrayWithObjects:@"-pkg", modInstaller, @"-target", @"/", nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:[self authRef]];
	[sh executeCommand:InstallerLocation withArgs:args];
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

-(IBAction)attemptConfiguration:(id)sender
{
	[self configureApacheSites];
	[self configurePassenger];
	[self configureApache];
	[configController checkConfiguration];
	
	if (isConfigured)
		[PassengerApacheController restartApache:[self authRef]];
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

-(IBAction)closeConfigurationSheet:(id)sender
{
	[NSApp endSheet:[configController configPanel]];
}

-(IBAction)openAdvancedSheet:(id)sender
{
	[[advancedController advancedHostsController] loadAllHosts];
	[NSApp beginSheet:[advancedController advancedPanel] modalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
}

-(IBAction)closeAdvancedSheet:(id)sender
{
	[NSApp endSheet:[advancedController advancedPanel]];
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
