//
//  PassengerApplication.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerApplication.h"

#import <OpenDirectory/OpenDirectory.h>

@implementation PassengerApplication

@synthesize name, address, port, path, aliases, rakeMode, appIsRunning, authRef;


-(id)init
{
	if (![super init])
		return nil;

	[self setAppIsRunning:NO];
	[self setPort:@"80"];
	[self setAuthRef:NULL];
	
	return self;
}

-(void)startApplication
{
	NSLog(@"Starting Site %@", [self name]);
	if (authRef == NULL)
		return;
	
	if (appIsRunning)
		return;
	
	[self createHost:address];
	[self setAppIsRunning:YES];
}

-(void)stopApplication
{
	NSLog(@"Stopping Site: %@",[self name]);
	
	if (authRef == NULL)
		return;
	
	if (!appIsRunning)
		return;
	
	[self removeHost:address];

	[self setAppIsRunning:NO];
}

-(void)restartApplication
{
	[self setAppIsRunning:YES];	
}

#pragma mark -
#pragma mark DSCL Commands
-(void)createHost:(NSString *)hostName
{
	NSLog(@"Creating Host...");
	if (authRef == NULL)
		return;

	NSString *dsclPath = [NSString stringWithFormat:@"/Local/Default/Hosts/%@",hostName];
	NSArray *args = [NSArray arrayWithObjects:@"localhost", @"-create", dsclPath, @"IPAddress", @"127.0.0.1", nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:[self authRef]];
	[sh executeCommand:@"/usr/bin/dscl" withArgs:args];
}

-(void)removeHost:(NSString *)hostName
{
	if (authRef == NULL)
		return;
	
	NSLog(@"Removing Host...");
	
	NSString *dsclPath = [NSString stringWithFormat:@"/Local/Default/Hosts/%@",hostName];
	NSArray *args = [NSArray arrayWithObjects:@"localhost", @"-delete", dsclPath, nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:[self authRef]];
	[sh executeCommand:@"/usr/bin/dscl" withArgs:args];
}

#pragma mark -
#pragma mark File Operations

/*  Sample Config File
 
 <VirtualHost *:80>
 ServerName www.yourhost.com
 DocumentRoot /somewhere/public    # <-- be sure to point to 'public'!
 <Directory /somewhere/public>
 AllowOverride all              # <-- relax Apache security settings
 Options -MultiViews            # <-- MultiViews must be turned off
 </Directory>
 </VirtualHost>
 
 */

@end
