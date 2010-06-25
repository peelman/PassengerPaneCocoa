//
//  PassengerApplication.h
//  PassengerPaneCocoa
//
//  Created by Nick Peelman on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PassengerApplication : NSObject {
	NSString *name, *address, *port, *path;
	NSArrayController *aliases;
	NSNumber *rakeMode;
	BOOL isRunning;
	
}
@property (copy) NSString *name, *address, *port, *path;
@property (retain) NSArrayController *aliases;
@property (copy) NSNumber *rakeMode;
@property BOOL isRunning;

-(void)startApplication;
-(void)stopApplication;
-(void)restartApplication;
-(void)createHost:(NSString *)hostName;


@end
