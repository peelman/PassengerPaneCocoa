//  PassengerApplication.h
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import <Cocoa/Cocoa.h>

#import "PassengerShared.h"

@interface PassengerApplication : NSObject {
	NSString *name, *address, *port, *path, *filename;
	NSNumber *rakeMode;
	BOOL appIsActive, appHasChanges;
	
	AuthorizationRef authRef;
	
}
@property (copy) NSString *name, *address, *port, *path, *filename;
@property (copy) NSNumber *rakeMode;
@property BOOL appIsActive, appHasChanges;
@property AuthorizationRef authRef;

-(void)loadConfigFromPath:(NSString *)p;
-(void)saveConfig;
-(void)deleteConfig;

@end
