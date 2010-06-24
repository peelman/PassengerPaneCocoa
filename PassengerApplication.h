//
//  PassengerApplication.h
//  PassengerPaneCocoa
//
//  Created by Nick Peelman on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PassengerApplication : NSObject {
	NSString *name, *address, *path;
	NSArrayController *aliases;
	NSNumber *railsMode;
	BOOL isRunning;
	
}
@property (copy) NSString *name, *address, *path;
@property (retain) NSArrayController *aliases;
@property (copy) NSNumber *railsMode;
@property BOOL isRunning;

-(void)startApplication;
-(void)stopApplication;
-(void)restartApplication;


@end
