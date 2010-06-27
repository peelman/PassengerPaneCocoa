//  HostsController.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "HostsController.h"


@implementation HostsController


#pragma mark -
#pragma mark DSCL Commands

+(void)createHost:(NSString *)hostName withAuthRef:(AuthorizationRef)authRef
{
	NSLog(@"Creating Host...");
	if (authRef == NULL)
		return;

	NSString *dsclPath = [NSString stringWithFormat:@"/Local/Default/Hosts/%@",hostName];
	NSArray *args = [NSArray arrayWithObjects:@"localhost", @"-create", dsclPath, @"IPAddress", @"127.0.0.1", nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:authRef];
	[sh executeCommand:@"/usr/bin/dscl" withArgs:args];
}

+(void)removeHost:(NSString *)hostName withAuthRef:(AuthorizationRef)authRef
{
	if (authRef == NULL)
		return;
	
	NSLog(@"Removing Host...");
	
	NSString *dsclPath = [NSString stringWithFormat:@"/Local/Default/Hosts/%@",hostName];
	NSArray *args = [NSArray arrayWithObjects:@"localhost", @"-delete", dsclPath, nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:authRef];
	[sh executeCommand:@"/usr/bin/dscl" withArgs:args];
}

@end
