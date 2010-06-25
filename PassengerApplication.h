//
//  PassengerApplication.h
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//
#import <Cocoa/Cocoa.h>


@interface PassengerApplication : NSObject {
	NSString *name, *address, *port, *path;
	NSArrayController *aliases;
	NSNumber *rakeMode;
	BOOL appIsRunning;
	
}
@property (copy) NSString *name, *address, *port, *path;
@property (retain) NSArrayController *aliases;
@property (copy) NSNumber *rakeMode;
@property BOOL appIsRunning;

-(void)startApplication;
-(void)stopApplication;
-(void)restartApplication;
-(void)createHost:(NSString *)hostName;


@end
