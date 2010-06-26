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
	ApacheStopArgs = [NSArray arrayWithObjects:ServiceApacheIdent, @"stop"];
	ApacheStartArgs = [NSArray arrayWithObjects:ServiceApacheIdent, @"start"];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	
	[sh setAuthorizationRef:authRef];
	[sh executeCommand:ServiceLocation withArgs:ApacheStopArgs];
	[sh executeCommand:ServiceLocation withArgs:ApacheStartArgs];
	
}

@end
