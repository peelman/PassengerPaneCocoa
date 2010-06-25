//
//  PassengerApplication.m
//  PassengerPaneCocoa
//
//  Created by Nick Peelman on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PassengerApplication.h"

#import <OpenDirectory/OpenDirectory.h>

@implementation PassengerApplication

@synthesize name, address, port, path, aliases, rakeMode, isRunning;


-(id)init
{
	if (![super init])
		return nil;

	isRunning = NO;
	
	return self;
}

-(void)startApplication
{
	[self createHost:address];
	
	if (! isRunning)
		[self setIsRunning:YES];
	else
		[self stopApplication];
}

-(void)stopApplication
{
	[self setIsRunning:NO];
}

-(void)restartApplication
{
	[self setIsRunning:YES];	
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
