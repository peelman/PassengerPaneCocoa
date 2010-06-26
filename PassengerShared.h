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
extern NSString * const LaunchdLocation; 
extern NSString * const LaunchdApacheIdent;

#pragma mark -
#pragma mark Apache Constants
extern NSString * const ApacheLocation;
extern NSString * const ApacheRestartCommand;
extern NSString * const ApacheConfDir;

#pragma mark -
#pragma mark Ruby and Passenger Constants
extern NSString * const RubyLocation;
extern NSString * const PassengerConfigTool;
extern NSString * const PassengerCurrentVersDir;
extern NSString * const PassengerModuleLocation;

#pragma mark -
#pragma mark PassengerPaneCocoa Constants
extern NSString * const PPCBundleID;
extern NSString * const PPCApacheConfigFile;
extern NSString * const SitesConfDir;
extern NSString * const ConfExtension;
extern NSString * const DisabledExtension;


@end
