#!/bin/sh

# passenger-create-link.sh
# PassengerPaneCocoa
#
#	Copyright (c) 2010 Nick Peelman <nick@peelman.us>
#


ln -s `/usr/bin/passenger-config --root` /Library/Ruby/Gems/1.8/gems/passenger-current

if [ ! -e /Library/Ruby/Gems/1.8/gems/passenger-current ]; then
	exit 1;
fi

exit 0;


