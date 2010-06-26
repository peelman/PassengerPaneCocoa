//  PassengerController.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerController.h"
#import "PassengerApplication.h"

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
	[sitesTableView setAllowsMultipleSelection:YES];
	[sites setSelectsInsertedObjects:YES];
	
    [authView setString:kAuthorizationRightExecute];
	[authView setDelegate:self];
    [authView updateStatus:authView];
	[authView setAutoupdate:YES];
	
	[self checkConfiguration];
	
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
		[sh setAuthorizationRef:[[authView authorization] authorizationRef]];
		[sh executeCommand:@"/bin/mkdir" withArgs:args];
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
	
	[fm release];
}

-(void)configureApache
{
	[statusText setStringValue:@"Configuring Apache..."];
	NSLog(@"%@", [statusText stringValue]);
	
	NSFileManager *fm = [[NSFileManager alloc] init];
	NSBundle *b = [NSBundle bundleWithIdentifier:PPCBundleID];
	NSString *confFilePath = [b pathForResource:PPCApacheConfigFile ofType:ConfExtension];

	if (![fm fileExistsAtPath:[NSString stringWithFormat:@"%@%@",ApacheConfDir,PPCApacheConfigFile]])
	{
		NSArray *args = [NSArray arrayWithObjects:confFilePath, ApacheConfDir, nil];
		SecurityHelper *sh = [SecurityHelper sharedInstance];
		[sh setAuthorizationRef:[[authView authorization] authorizationRef]];
		[sh executeCommand:@"/bin/cp" withArgs:args];
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
						 informativeTextWithFormat:@"Installing Passenger can take a few minutes. System Preferences may become unresponsive (spinning beach ball of doom) during this time.  This is normal! However, if the process lasts longer than a few minutes, you may need to Force Quit System Prefs"];
	[alert setIcon:[NSImage imageNamed:NSImageNameInfo]];
	[alert runModal];
	
	NSBundle *bundle = [NSBundle bundleWithIdentifier:PPCBundleID];
	NSString *passengerInstaller = [bundle pathForResource:@"install-passenger" ofType:@"pkg"];

	NSArray *args = [NSArray arrayWithObjects:@"-pkg", passengerInstaller, @"-target", @"/", nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:[[authView authorization] authorizationRef]];
	[sh executeCommand:@"/usr/sbin/installer" withArgs:args];
}
	
-(void)createPassengerSymLink
{
	NSBundle *bundle = [NSBundle bundleWithIdentifier:PPCBundleID];
	NSString *passengerLinkScript = [bundle pathForResource:@"passenger-create-link" ofType:@"sh"];

	NSArray *args = [NSArray arrayWithObjects:passengerLinkScript, nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:[[authView authorization] authorizationRef]];
	[sh executeCommand:@"/bin/bash" withArgs:args];
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

-(IBAction)attemptConfiguration:(id)sender
{
	[self configureApacheSites];
	[self configurePassenger];
	[self configureApache];
	[self checkConfiguration];
	
	if (isConfigured)
		[PassengerApacheController restartApache:[[authView authorization] authorizationRef]];
}

#pragma mark -
#pragma mark SFAuthorizationView Delegate Methods
- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)view
{
	for (PassengerApplication *pa in [sites arrangedObjects])
		[pa setAuthRef:[[authView authorization] authorizationRef]];
	
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

@end
