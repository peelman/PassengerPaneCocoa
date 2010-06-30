//  ConfigurationController.m
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//


#import "ConfigurationController.h"
#import "PassengerController.h"
#import "SecurityHelper.h"

@implementation ConfigurationController

@synthesize configPanel, sitesPathFound, rubyFound, passengerFound, passengerLinked, apacheModFound, apacheConfigured;
@synthesize sitesPath, rubyPath, passengerPath, apacheModPath, apacheConfigPath;

-(BOOL)checkSitesDirectoryConfig
{
	NSFileManager *fm = [NSFileManager defaultManager];
	
	BOOL isDir = NO;
	if (![fm fileExistsAtPath:SitesConfDir isDirectory:&isDir] || !isDir)
	{
		[statusText setStringValue:@"Config Directory Doesn't Exist"];
		NSLog(@"%@",[statusText stringValue]);
		return NO;
	}
	[self setSitesPath:[SitesConfDir stringByDeletingLastPathComponent]];
	[self setSitesPathFound:YES];;
	return YES;
}

-(BOOL)checkRubyConfig
{
	return NO;
}

-(BOOL)checkPassengerConfig
{
	return NO;	
}

-(BOOL)checkPassengerLinked
{
	return NO;
}

-(BOOL)checkApacheMod
{
	return NO;
}

-(BOOL)checkApacheConfig
{
	return NO;
}

-(void)checkConfiguration
{
	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL isDir = NO;
	
	// Locate Config Dir
	if (![self checkSitesDirectoryConfig])
		return;
	
	// Locate Ruby
	if (![fm fileExistsAtPath:RubyLocation])
	{
		[statusText setStringValue:@"Ruby Not Found"];
		NSLog(@"%@",[statusText stringValue]);
		return;
	}
	
	// Locate Passenger
	if (![fm fileExistsAtPath:PassengerConfigTool])
	{
		[statusText setStringValue:@"Passenger Not Found"];
		NSLog(@"%@",[statusText stringValue]);
		return;
	}
	
	// Locate Passsenger Link
	if (![fm fileExistsAtPath:PassengerCurrentVersDir isDirectory:&isDir] || !isDir)
	{
		[statusText setStringValue:@"Passenger Not Linked"];
		NSLog(@"%@", [statusText stringValue]);
		return;
	}
	
	// Locate Passenger Apache Module
	if (![fm fileExistsAtPath:PassengerModuleLocation])
	{
		[statusText setStringValue:@"Passenger Apache Module Not Found"];
		NSLog(@"%@",[statusText stringValue]);
		return;
	}
	
	// Locate Passenger Apache Config File
	if (![fm fileExistsAtPath:[NSString stringWithFormat:@"%@%@.%@",ApacheConfDir, PPCApacheConfigFile, ConfExtension]])
	{
		[statusText setStringValue:@"Apache Not Configured to run Passenger"];
		NSLog(@"%@",[statusText stringValue]);
		return;
	}
	
	[statusText setStringValue:@""];
	[g_passengerController setIsConfigured:YES];
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
		[sh setAuthorizationRef:[g_passengerController authRef]];
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
		[sh setAuthorizationRef:[g_passengerController authRef]];
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
	[sh setAuthorizationRef:[g_passengerController authRef]];
	[sh executeCommand:InstallerLocation withArgs:args];
}

-(void)createPassengerSymLink
{
	NSString *passengerLinkScript = [paneBundle pathForResource:PPCCreateLinkScriptName ofType:ShellScriptExtension];
	
	NSArray *args = [NSArray arrayWithObjects:passengerLinkScript, nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:[g_passengerController authRef]];
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
	[sh setAuthorizationRef:[g_passengerController authRef]];
	[sh executeCommand:InstallerLocation withArgs:args];
}

-(IBAction)attemptConfiguration:(id)sender
{
	[self configureApacheSites];
	[self configurePassenger];
	[self configureApache];
	[self checkConfiguration];
	
//	if (isConfigured)
//		[PassengerApacheController restartApache:[g_passengerController authRef]];
}

-(IBAction)closeConfigurationSheet:(id)sender
{
	[NSApp endSheet:[self configPanel]];
}

@end
