//  PassengerShared.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerShared.h"


@implementation PassengerShared

#pragma mark -
#pragma mark Service Constants
NSString * const LaunchdLocation = @"/bin/launchctl";
NSString * const LaunchdApacheConf = @"/System/Library/LaunchDaemons/org.apache.httpd.plist";

#pragma mark -
#pragma mark Apache Constants
NSString * const ApacheLocation = @"/usr/sbin/httpd";
NSString * const ApacheConfDir = @"/private/etc/apache2/other/";

#pragma mark -
#pragma mark Ruby and Passenger Constants
NSString * const RubyLocation = @"/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby";
NSString * const PassengerConfigTool = @"/usr/bin/passenger-config";
NSString * const PassengerCurrentVersDir = @"/Library/Ruby/Gems/1.8/gems/passenger-current/";
NSString * const PassengerModuleLocation = @"/Library/Ruby/Gems/1.8/gems/passenger-current/ext/apache2/mod_passenger.so";

#pragma mark -
#pragma mark System Constants
NSString * const BashLocation = @"/bin/bash";
NSString * const CpLocation = @"/bin/cp";
NSString * const MvLocation = @"/bin/mv";
NSString * const RmLocation = @"/bin/rm";
NSString * const MkdirLocation = @"/bin/mkdir";
NSString * const InstallerLocation = @"/usr/sbin/installer";

#pragma mark -
#pragma mark PassengerPaneCocoa Constants

PassengerController *g_passengerController;

NSString * const PPCBundleID = @"us.peelman.PassengerPaneCocoa";
NSString * const PPCApacheConfigFile = @"httpd-passengerpanecocoa";
NSString * const SitesConfDir = @"/private/etc/apache2/other/passengerpanecocoa-sites/";
NSString * const TempDir =  @"/private/tmp/";
NSString * const PPCCreateLinkScriptName = @"passenger-create-link";
NSString * const PPCInstallPassengerPackageName = @"install-passenger";
NSString * const PPCInstallPassengerApacheModPackageName = @"install-passenger-apache-mod";
#pragma mark -
#pragma mark File Extension Constants
NSString * const ConfExtension = @"conf";
NSString * const DisabledExtension = @"disabled";
NSString * const ShellScriptExtension = @"sh";
NSString * const PkgExtension = @"pkg";

@end
