//  PassengerApplication.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerApplication.h"

#import "HostsController.h"
#import "SecurityHelper.h"

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
	
	[HostsController createHost:address withAuthRef:authRef];
	[self setAppIsRunning:YES];
}

-(void)stopApplication
{
	NSLog(@"Stopping Site: %@",[self name]);
	
	if (authRef == NULL)
		return;
	
	if (!appIsRunning)
		return;
	
	[HostsController removeHost:address withAuthRef:authRef];

	[self setAppIsRunning:NO];
}

-(void)restartApplication
{
	[self setAppIsRunning:YES];	
}

#pragma mark -
#pragma mark File Operations

/*  Sample Config File
 #PassengerPane SiteName [sitenamehere]
 <VirtualHost *:80>
 ServerName www.yourhost.com
 DocumentRoot /somewhere/public    # <-- be sure to point to 'public'!
 <Directory /somewhere/public>
 AllowOverride all              # <-- relax Apache security settings
 Options -MultiViews            # <-- MultiViews must be turned off
 	Order deny,allow
	Allow from all
 </Directory>
 </VirtualHost>
 
 */

@end
