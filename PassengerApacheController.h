//  PassengerApacheController.h
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import <Cocoa/Cocoa.h>
#import "PassengerShared.h"
#import "SecurityHelper.h"

@interface PassengerApacheController : NSObject {
	NSArray *ApacheStopArgs;
	NSArray *ApacheStartArgs;
}

+(void)restartApache:(AuthorizationRef)authRef;

@end
