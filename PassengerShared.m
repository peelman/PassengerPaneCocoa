//  PassengerShared.m
//  PassengerPaneCocoa
//
//	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
//

#import "PassengerShared.h"


@implementation PassengerShared

#pragma mark -
#pragma mark Service Constants
NSString * const ServiceLocation = @"/sbin/service";
NSString * const ServiceApacheIdent = @"org.apache.httpd";

#pragma mark -
#pragma mark Apache Constants
NSString * const ApacheLocation = @"/usr/sbin/httpd";
NSString * const ApacheConfDir = @"/private/etc/apache2/other/";

#pragma mark -
#pragma mark Ruby and Passenger Constants
NSString * const RubyLocation = @"/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby";
NSString * const PassengerDir = @"/Library/Ruby/Gems/1.8/gems/passenger-current/";
NSString * const PassengerModuleLocation = @"/Library/Ruby/Gems/1.8/gems/passenger-current/ext/apache2/mod_passenger.so";

#pragma mark -
#pragma mark PassengerPaneCocoa Constants
NSString * const SitesConfDir = @"/private/etc/apache2/other/passengerpanecocoa-sites/";
NSString * const SitesConfEnabledExtension = @".conf";
NSString * const SitesConfDisabledExtension = @".disabled";

@end
