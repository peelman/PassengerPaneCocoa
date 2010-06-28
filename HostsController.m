//  HostsController.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "HostsController.h"

#import "PassengerApplication.h"
#import "PassengerController.h"
#import "SecurityHelper.h"

@implementation HostsController


#pragma mark -
#pragma mark DSCL Commands

+(void)createHost:(NSString *)hostName withAuthRef:(AuthorizationRef)authRef
{
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
	
	int numberInUse = 0;
	
	for (PassengerApplication *site in [[g_passengerController sites] arrangedObjects])
		if ([[site address] isEqualTo:hostName])
			numberInUse++;
	
	if (numberInUse > 1)
		return;

	NSString *dsclPath = [NSString stringWithFormat:@"/Local/Default/Hosts/%@",hostName];
	NSArray *args = [NSArray arrayWithObjects:@"localhost", @"-delete", dsclPath, nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:authRef];
	[sh executeCommand:@"/usr/bin/dscl" withArgs:args];
}

@end
