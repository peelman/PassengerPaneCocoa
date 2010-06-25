//  PassengerShared.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerShared.h"


@implementation PassengerShared
NSString * const ApacheLocation = @"/usr/sbin/httpd";
NSString * const ApacheRestartCommand = @"/sbin/service org.apache.httpd stop; /sbin/service org.apache.httpd start";
NSString * const ApacheConfDir = @"/private/etc/apache2/other/";

NSString * const RubyLocation = @"/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby";
NSString * const PassengerDir = @"/Library/Ruby/Gems/1.8/gems/passenger-current/";
NSString * const PassengerModuleLocation = @"/Library/Ruby/Gems/1.8/gems/passenger-current/ext/apache2/mod_passenger.so";

NSString * const SitesConfDir = @"/private/etc/apache2/other/passengerpanecocoa-sites/";
NSString * const SitesConfEnabledExtension = @".conf";
NSString * const SitesConfDisabledExtension = @".disabled";

@end
