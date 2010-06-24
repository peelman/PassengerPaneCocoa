//
//  PassengerApplication.m
//  PassengerPaneCocoa
//
//  Created by Nick Peelman on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PassengerApplication.h"


@implementation PassengerApplication

@synthesize name, address, path, aliases, railsMode, isRunning;


-(id)init
{
	if (![super init])
		return nil;

	isRunning = NO;
	
	return self;
}

-(void)startApplication
{
	[self setIsRunning:YES];
}

-(void)stopApplication
{
	[self setIsRunning:NO];
}

-(void)restartApplication
{
	[self setIsRunning:YES];	
}

@end
