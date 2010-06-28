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
	BOOL appIsActive;
	
	AuthorizationRef authRef;
	
}
@property (copy) NSString *name, *address, *port, *path, *filename;
@property (copy) NSNumber *rakeMode;
@property BOOL appIsActive;
@property AuthorizationRef authRef;

-(void)enableConfig;
-(void)disableConfig;
-(void)saveConfig;
-(void)deleteConfig;

@end
