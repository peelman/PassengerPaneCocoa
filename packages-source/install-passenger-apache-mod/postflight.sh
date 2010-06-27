#!/bin/bash

if [ ! -e /usr/bin/passenger-config ]; then
	exit 1;
fi

/usr/bin/passenger-install-apache2-module -a

exit 0;