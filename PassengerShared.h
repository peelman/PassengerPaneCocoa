//  PassengerShared.h
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import <Cocoa/Cocoa.h>


@interface PassengerShared : NSObject {

}
#pragma mark -
#pragma mark Service Constants
extern NSString * const ServiceLocation; 
extern NSString * const ServiceApacheIdent;

#pragma mark -
#pragma mark Apache Constants
extern NSString * const ApacheLocation;
extern NSString * const ApacheRestartCommand;
extern NSString * const ApacheConfDir;

#pragma mark -
#pragma mark Ruby and Passenger Constants
extern NSString * const RubyLocation;
extern NSString * const PassengerDir;
extern NSString * const PassengerModuleLocation;

#pragma mark -
#pragma mark PassengerPaneCocoa Constants
extern NSString * const PPCApacheConfigFile;
extern NSString * const SitesConfDir;
extern NSString * const ConfExtension;
extern NSString * const DisabledExtension;


@end
