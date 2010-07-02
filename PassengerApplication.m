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
	
	return self;
}

#pragma mark -
#pragma mark File Operations

-(void)saveConfig
{
	if ([filename isEqualToString:@""])
		return;
	
	[self deleteConfig];
	NSString *extension = appIsActive ? ConfExtension : DisabledExtension;
	[self setFilename:[NSString stringWithFormat:@"%@.%@",address,extension]];
	NSString *tempDestination = [TempDir stringByAppendingPathComponent:filename];
	NSString *finalDestination = [SitesConfDir stringByAppendingPathComponent:filename];
	
	NSLog(@"Attempting to save %@ to filename: %@", name, filename);
	NSMutableString *outputBuffer = [[NSMutableString alloc] init];
	
	[outputBuffer appendString:[NSString stringWithFormat:@"#PassengerPane SiteName %@\r\n", name]];
	[outputBuffer appendString:[NSString stringWithFormat:@"<VirtualHost %@:80>\r\n", address]];
	[outputBuffer appendString:[NSString stringWithFormat:@"ServerName %@\r\n", address]];
	[outputBuffer appendString:[NSString stringWithFormat:@"DocumentRoot %@\r\n", path]];
	[outputBuffer appendString:[NSString stringWithFormat:@"<Directory %@>\r\n", path]];
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
