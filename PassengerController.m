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
	isDir = NO;
	if (![fm fileExistsAtPath:PassengerDir isDirectory:&isDir])
	{
		[statusText setStringValue:@"Passenger Not Found"];
		[statusImage setImage:[NSImage imageNamed:NSImageNameStatusPartiallyAvailable]];
		NSLog(@"%@",[statusText stringValue]);
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
	if (![fm fileExistsAtPath:[NSString stringWithFormat:@"%@%@",ApacheConfDir,PPCApacheConfigFile]])
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
	NSFileManager *fm = [[NSFileManager alloc] init];
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	BOOL isDir = NO;	
	
	if (![fm fileExistsAtPath:SitesConfDir isDirectory:&isDir] || !isDir)
	{
		NSArray *args = [NSArray arrayWithObjects:SitesConfDir, nil];
		[sh setAuthorizationRef:[[authView authorization] authorizationRef]];
		[sh executeCommand:@"/bin/mkdir" withArgs:args];
	}
	
	[fm release];	
}

-(void)configurePassenger
{
	NSFileManager *fm = [[NSFileManager alloc] init];
	// Locate Passenger Apache Module
	if (![fm fileExistsAtPath:PassengerModuleLocation])
	{
		
	}
	[fm release];
}

-(void)configureApache
{
	NSFileManager *fm = [[NSFileManager alloc] init];
	NSBundle *b = [NSBundle mainBundle];
	NSString *confFilePath = [b pathForResource:PPCApacheConfigFile ofType:ConfExtension];
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	NSLog(@"%@",confFilePath);
	// Locate Passenger Apache Config File
	if (![fm fileExistsAtPath:[NSString stringWithFormat:@"%@%@",ApacheConfDir,PPCApacheConfigFile]])
	{
		NSArray *args = [NSArray arrayWithObjects:[b pathForResource:PPCApacheConfigFile ofType:ConfExtension], ApacheConfDir, nil];
		[sh setAuthorizationRef:[[authView authorization] authorizationRef]];
		[sh executeCommand:@"/bin/cp" withArgs:args];
	}
		 
	[fm release];
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

-(IBAction)attemptConfiguration:(id)sender
{
	[self configureApache];
	[self checkConfiguration];
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
