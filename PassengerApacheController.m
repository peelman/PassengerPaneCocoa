//  PassengerApacheController.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerApacheController.h"


@implementation PassengerApacheController

#pragma mark -
#pragma mark Apache Commands
+(void)restartApache:(AuthorizationRef)authRef
{
	NSArray *apacheStopArgs = [NSArray arrayWithObjects:ServiceApacheIdent, @"stop", nil];
	NSArray *apacheStartArgs = [NSArray arrayWithObjects:ServiceApacheIdent, @"start", nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	
	[sh setAuthorizationRef:authRef];
	[sh executeCommand:ServiceLocation withArgs:apacheStopArgs];
	[sh executeCommand:ServiceLocation withArgs:apacheStartArgs];
	
}

@end
