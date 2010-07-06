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

-(id)init
{
	if (![super init])
		return nil;
	
	fm = [NSFileManager defaultManager];
	
	[self setSitesPathFound:NO];
	
	return self;
}

-(BOOL)checkSitesDirectoryConfig
{
	BOOL isDir = NO;
	if (![fm fileExistsAtPath:SitesConfDir isDirectory:&isDir] || !isDir)
	{
		[self setSitesPath:@""];
		[self setSitesPathFound:NO];
		
		[statusText setStringValue:@"Config Directory Doesn't Exist"];
		NSLog(@"%@",[statusText stringValue]);

		return NO;
	}
	
	[self setSitesPath:SitesConfDir];
	[self setSitesPathFound:YES];
	
	return YES;
}

-(BOOL)checkRubyConfig
{
	if (![fm fileExistsAtPath:RubyLocation])
	{
		[self setRubyPath:@""];
		[self setRubyFound:NO];
		
		[statusText setStringValue:@"Ruby Not Found"];
		NSLog(@"%@",[statusText stringValue]);
		
		return NO;
	}
	
	[self setRubyPath:RubyLocation];
	[self setRubyFound:YES];
	return YES;
}

-(BOOL)checkPassengerConfig
{
	if (![fm fileExistsAtPath:PassengerConfigTool])
	{
		[self setPassengerPath:@""];
		[self setPassengerFound:NO];
		
		[statusText setStringValue:@"Passenger Not Found"];
		NSLog(@"%@",[statusText stringValue]);
		
		return NO;
	}
	
	[self setPassengerPath:[PassengerShared runTask:PassengerConfigTool withArgs:[NSArray arrayWithObjects:@"--root",nil]]];
	[self setPassengerFound:YES];
	return YES;
}

-(BOOL)checkPassengerLinked
{
	BOOL isDir = NO;
	if (![fm fileExistsAtPath:PassengerCurrentVersDir isDirectory:&isDir] || !isDir)
	{
		[self setPassengerLinked:NO];
		
		[statusText setStringValue:@"Passenger Not Linked"];
		NSLog(@"%@", [statusText stringValue]);
		
		return NO;
	}
	
	[self setPassengerLinked:YES];
	
	return YES;
}

-(BOOL)checkApacheMod
{
	if (![fm fileExistsAtPath:PassengerModuleLocation])
	{
		[self setApacheModPath:@""];
		[self setApacheModFound:NO];
		
		[statusText setStringValue:@"Passenger Apache Module Not Found"];
		NSLog(@"%@",[statusText stringValue]);
		
		return NO;
	}
	
	[self setApacheModPath:PassengerModuleLocation];
	[self setApacheModFound:YES];
	return YES;
}

-(BOOL)checkApacheConfig
{
	NSString *configPath = [NSString stringWithFormat:@"%@%@.%@",ApacheConfDir, PPCApacheConfigFile, ConfExtension];
	if (![fm fileExistsAtPath:configPath])
	{
		[self setApacheConfigPath:@""];
		[self setApacheConfigured:NO];
		
		[statusText setStringValue:@"Apache Not Configured to run Passenger"];
		NSLog(@"%@",[statusText stringValue]);
		
		return NO;
	}
	
	[self setApacheConfigPath:configPath];
	[self setApacheConfigured:YES];
	return YES;
}

-(void)checkConfiguration
{
	[self checkConfigurationAndAutoConfigure:NO];
}

-(void)checkConfigurationAndAutoConfigure:(BOOL)autoConfig
{
	[g_passengerController setIsConfigured:NO];
	
	// Locate Config Dir
	if (![self checkSitesDirectoryConfig])
	{
		if (autoConfig)
		{
			[self configureApacheSites];
		} 
		else
			return;
	}
	
	// Locate Ruby
	if (![self checkRubyConfig])
		return;
	
	// Locate Passenger
	if (![self checkPassengerConfig])
	{
		if (autoConfig)
		{
			[self configurePassenger];
		} else
			return;
	}
	
	// Locate Passsenger Link
	if (![self checkPassengerLinked])
	{		
		if (autoConfig) 
		{
			[self configurePassenger];
		} 
		else
			return;		
	}
	
	// Locate Passenger Apache Module
	if (![self checkApacheMod])
	{
		if (autoConfig) 
		{
			[self configurePassenger];
		}
		else
			return;		
	}

	
	// Locate Passenger Apache Config File
	if (![self checkApacheConfig])
	{
		if (autoConfig)
		{
			[self configureApache];
		}
		else
			return;
	}

	
	[statusText setStringValue:@""];
	[g_passengerController setIsConfigured:YES];
	[g_passengerController loadSites];
}

-(void)configureApacheSites
{
	[statusText setStringValue:@"Configuring Apache Sites..."];
	NSLog(@"%@", [statusText stringValue]);
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
	[self checkConfigurationAndAutoConfigure:YES];
	[self checkConfiguration];
//	[self configurePassenger];
//	[self configureApache];
//	[self checkConfiguration];
	
//	if (isConfigured)
//		[PassengerApacheController restartApache:[g_passengerController authRef]];
}

-(IBAction)closeConfigurationSheet:(id)sender
{
	[NSApp endSheet:[self configPanel]];
}

@end
