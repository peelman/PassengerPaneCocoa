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


-(void)startApplication
{
	isRunning = YES:
}

-(void)stopApplication
{
	isRunning = NO;
}

-(void)restartApplication
{
	isRunning = YES;
	
}

@end
