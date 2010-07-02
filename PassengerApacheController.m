//  PassengerApacheController.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerApacheController.h"

#import "SecurityHelper.h"

@implementation PassengerApacheController

#pragma mark -
#pragma mark Apache Commands
+(void)restartApache:(AuthorizationRef)authRef
{
	NSArray *apacheStopArgs = [NSArray arrayWithObjects:@"unload", LaunchdApacheConf, nil];
	NSArray *apacheStartArgs = [NSArray arrayWithObjects:@"load", LaunchdApacheConf, nil];
	
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:authRef];
	[sh executeCommand:LaunchdLocation withArgs:apacheStopArgs];
	[sh executeCommand:LaunchdLocation withArgs:apacheStartArgs];
}

+(BOOL)isApacheRunning
{
	
}

@end
