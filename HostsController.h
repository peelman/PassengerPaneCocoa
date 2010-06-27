//  HostsController.h
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import <Cocoa/Cocoa.h>

#import "PassengerShared.h"

@interface HostsController : NSObject {
	
	
	
}

+(void)createHost:(NSString *)hostName withAuthRef:(AuthorizationRef)authRef;
+(void)removeHost:(NSString *)hostName withAuthRef:(AuthorizationRef)authRef;

@end
