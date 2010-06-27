//  AdvancedHostsController.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "HostsController.h"
#import "AdvancedHostsController.h"
#import "PassengerController.h"
#import "PassengerApplication.h"

@implementation AdvancedHostsController

-(void)loadAllHosts
{
	// Needs Lots of work...
	[hostsArray removeObjects:[hostsArray arrangedObjects]];
	
	NSTask *task = [[NSTask alloc] init];
    NSArray *arguments = [NSArray arrayWithObjects: @"localhost", @"-list", @"/Local/Default/Hosts", nil];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
	
    [task setLaunchPath: @"/usr/bin/dscl"];
	[task setArguments: arguments];
	[task setStandardOutput: pipe];
	[task launch];
    [task waitUntilExit];

	NSData *data = [file readDataToEndOfFile];
    NSString *hostsReturn = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

	NSLog(@"%@",hostsReturn);
	NSMutableArray *allHosts = [[NSMutableArray alloc] init];
	
	for (NSString *i in [hostsReturn componentsSeparatedByString:@"\n"])
	{	
		if ([i isEqualTo:@""]) continue;
		
		NSMutableDictionary *md = [NSMutableDictionary dictionaryWithObject:i forKey:@"address"];
		for (PassengerApplication *site in [[controller sites] arrangedObjects])
			if ([[site address] isEqualTo:i])
			{
				[md setValue:[NSNumber numberWithBool:YES] forKey:@"inUse"];
				break;
			}
			else
				[md setValue:[NSNumber numberWithBool:NO] forKey:@"inUse"];

		[allHosts addObject:md];
	}
	[hostsArray addObjects:allHosts];
}
-(IBAction)removeSelectedHost:(id)sender
{
	for (id i in [hostsArray selectedObjects])
	{
		[HostsController removeHost:[i valueForKey:@"address"] withAuthRef:[controller authRef]];
	}
	[self loadAllHosts];
}

-(IBAction)reloadHosts:(id)sender
{
	[self loadAllHosts];
}

@end
