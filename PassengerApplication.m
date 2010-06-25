//
//  PassengerApplication.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerApplication.h"

#import <OpenDirectory/OpenDirectory.h>

@implementation PassengerApplication

@synthesize name, address, port, path, aliases, rakeMode, appIsRunning;


-(id)init
{
	if (![super init])
		return nil;

	[self setAppIsRunning:NO];
	[self setPort:@"80"];
	return self;
}

-(void)startApplicationWithAuthorization:(SFAuthorization *)auth
{
	authorization = auth;
	
	if (appIsRunning)
	{
		NSLog(@"Is Running, stopping");
		[self stopApplication];
		return;
	}

	
	[self createHost:address];
	[self setAppIsRunning:YES];
}

-(void)stopApplication
{
	[self setAppIsRunning:NO];
}

-(void)restartApplication
{
	[self setAppIsRunning:YES];	
}

-(void)createHost:(NSString *)hostName
{
	NSLog(@"Creating Host...");

	SecurityHelper *sh = [SecurityHelper sharedInstance];
	NSArray *args = [NSArray arrayWithObjects:@"localhost ", @"-create", @"/LocalDefault/Hosts/", @"testing", @"IPAddress", @"127.0.0.1",nil];
	
	[sh setAuthorizationRef:[authorization authorizationRef]];
	[sh executeCommand:@"/usr/bin/dscl" withArgs:args];
	
	
}

@end
