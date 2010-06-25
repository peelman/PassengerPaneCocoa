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

-(void)startApplication
{
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
	ODSession *mySession = [ODSession defaultSession];
	NSError *error;
	
	NSString *nodeName = @"/Local/Default/Hosts";
	
	ODNode *hostsNode = [ODNode nodeWithSession:mySession name:nodeName error:&error];
	
	for (id i in [hostsNode subnodeNamesAndReturnError:nil])
		NSLog(@"%@",i);
	
}

@end
