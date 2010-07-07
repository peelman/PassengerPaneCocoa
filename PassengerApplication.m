//  PassengerApplication.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerApplication.h"

#import "HostsController.h"
#import "SecurityHelper.h"

@implementation PassengerApplication

@synthesize name, address, port, path, filename, rakeMode, appIsActive, appHasChanges, authRef;

-(id)init
{
	if (![super init])
		return nil;

	[self setAppIsActive:YES];
	[self setAppHasChanges:YES];
	[self setPort:@"80"];
	[self setAuthRef:NULL];
	[self setRakeMode:[NSNumber numberWithInt:0]];
	
	return self;
}

-(void)restart
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *tmpPath = [path stringByAppendingString:@"tmp"];
	
	if (![fm fileExistsAtPath:tmpPath])
		[fm createDirectoryAtPath:tmpPath withIntermediateDirectories:NO attributes:nil error:nil];
	
	[PassengerShared runTask:@"/usr/bin/touch" withArgs:[NSArray arrayWithObject:[tmpPath stringByAppendingPathComponent:@"restart.txt"]]];
	
}

#pragma mark -
#pragma mark File Operations

-(void)loadConfigFromPath:(NSString *)p
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSLog(@"Testing: %@",p);
	if ([p isEqualToString:@""] || ![fm isReadableFileAtPath:[SitesConfDir stringByAppendingPathComponent:p]])
		return;
	
	NSString *inputFile = [NSString stringWithContentsOfFile:[SitesConfDir stringByAppendingPathComponent:p] encoding:NSUTF8StringEncoding error:nil];
	
	NSArray *fileLines = [inputFile componentsSeparatedByString:@"\r\n"];
	
	if (fileLines == nil)
	{
		NSLog(@"Invalid config file at path: %@",[SitesConfDir stringByAppendingPathComponent:p]);
		return;
	}
	
	[self setFilename:p];
	
	NSScanner *scan;
	
	// Extract the name, type, and value from each line and load into ivars
	
	for ( NSString *line in fileLines )
	{
		if ([line hasPrefix:@"#PassengerPane SiteName"])
		{
			NSArray *array = [line componentsSeparatedByString:@" "];
			
			if (![[array lastObject] isEqualToString:@""])
				[self setName:[array lastObject]];
		}
		
		if ([line hasPrefix:@"ServerName"])
		{
			NSArray *array = [line componentsSeparatedByString:@" "];
			
			if (![[array lastObject] isEqualToString:@""])
			{
				[self setAddress:[array lastObject]];
				[HostsController createHost:[array lastObject] withAuthRef:authRef];			
			}
		}
		
		if ([line hasPrefix:@"DocumentRoot"])
		{
			NSArray *array = [line componentsSeparatedByString:@" "];
			
			if (![[array lastObject] isEqualToString:@""])
			{
				NSString *pathToLoad = [[array lastObject] stringByDeletingLastPathComponent];
				[self setPath:pathToLoad];				
			}

		}
		
		if ([line hasPrefix:@"RailsEnv"])
		{
			NSArray *array = [line componentsSeparatedByString:@" "];
			
			if (![[array lastObject] isEqualToString:@"production"])
				[self setRakeMode:[NSNumber numberWithInt:0]];
			else
				[self setRakeMode:[NSNumber numberWithInt:1]];

		}
	 }
	 [self setAppHasChanges:NO];	
}

-(void)saveConfig
{
	if ([filename isEqualToString:@""])
		return;
	
	[self deleteConfig];
	NSString *extension = appIsActive ? ConfExtension : DisabledExtension;
	[self setFilename:[NSString stringWithFormat:@"%@.%@",address,extension]];
	NSString *tempDestination = [TempDir stringByAppendingPathComponent:filename];
	NSString *finalDestination = [SitesConfDir stringByAppendingPathComponent:filename];
	
	NSString *railsEnv;
	switch ([rakeMode intValue]) {
		case 0:
			railsEnv = RailsEnvProd;
			break;
		case 1:
			railsEnv = RailsEnvDev;
		default:
			break;
	}
	
	NSLog(@"Attempting to save %@ to filename: %@", name, filename);
	NSMutableString *outputBuffer = [[NSMutableString alloc] init];
	
	[outputBuffer appendString:[NSString stringWithFormat:@"#PassengerPane SiteName %@\r\n", name]];
	[outputBuffer appendString:[NSString stringWithFormat:@"<VirtualHost %@:80>\r\n", address]];
	[outputBuffer appendString:[NSString stringWithFormat:@"ServerName %@\r\n", address]];
	[outputBuffer appendString:[NSString stringWithFormat:@"DocumentRoot %@/public\r\n"]];
	[outputBuffer appendString:[NSString stringWithFormat:@"RailsEnv %@\r\n", railsEnv]];
	[outputBuffer appendString:[NSString stringWithFormat:@"<Directory %@/public>\r\n", path]];
	[outputBuffer appendString:@"\tAllowOverride all\r\n\tOptions -MultiViews\r\n"];
	[outputBuffer appendString:@"\tOrder deny,allow\r\n\tAllow from all\r\n"];
	[outputBuffer appendString:@"</Directory>\r\n</VirtualHost>\r\n"];
	
	[outputBuffer writeToFile:tempDestination atomically:YES encoding:NSUTF8StringEncoding error:NULL];

	[outputBuffer release];
	
	NSArray *args = [NSArray arrayWithObjects:tempDestination, finalDestination, nil];

	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:authRef];
	[sh executeCommand:CpLocation withArgs:args];
	
	[[NSFileManager defaultManager] removeItemAtPath:tempDestination error:nil];
	
	[self setAppHasChanges:NO];
	
}

-(void)deleteConfig
{
	if (filename == nil || [filename isEqualToString:@""])
		return;

	NSArray *args = [NSArray arrayWithObjects:[SitesConfDir stringByAppendingPathComponent:filename], nil];
	SecurityHelper *sh = [SecurityHelper sharedInstance];
	[sh setAuthorizationRef:authRef];
	[sh executeCommand:RmLocation withArgs:args];
}

/*  Sample Config File
 #PassengerPane SiteName [sitenamehere]
 <VirtualHost *:80>
 ServerName www.yourhost.com
 DocumentRoot /somewhere/public    # <-- be sure to point to 'public'!
 <Directory /somewhere/public>
 AllowOverride all              # <-- relax Apache security settings
 Options -MultiViews            # <-- MultiViews must be turned off
 	Order deny,allow
	Allow from all
 </Directory>
 </VirtualHost>
 
 */

@end
