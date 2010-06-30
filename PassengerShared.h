//  PassengerShared.h
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import <Cocoa/Cocoa.h>
#import <SecurityFoundation/SFAuthorization.h>

@class PassengerController;

@interface PassengerShared : NSObject {

}
#pragma mark -
#pragma mark Service Constants
extern NSString * const LaunchdLocation; 
extern NSString * const LaunchdApacheConf;

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
#pragma mark System Constants
extern NSString * const BashLocation;
extern NSString * const CpLocation;
extern NSString * const MvLocation;
extern NSString * const RmLocation;
extern NSString * const MkdirLocation;
extern NSString * const InstallerLocation;

#pragma mark -
#pragma mark PassengerPaneCocoa Constants
extern PassengerController * g_passengerController;
extern NSBundle * paneBundle;
extern NSString * const PPCBundleID;
extern NSString * const PPCApacheConfigFile;
extern NSString * const SitesConfDir;
extern NSString * const TempDir;
extern NSString * const PPCCreateLinkScriptName;
extern NSString * const PPCInstallPassengerPackageName;
extern NSString * const PPCInstallPassengerApacheModPackageName;

#pragma mark -
#pragma mark File Extension Constant
extern NSString * const ConfExtension;
extern NSString * const DisabledExtension;
extern NSString * const ShellScriptExtension;
extern NSString * const PkgExtension;


@end
