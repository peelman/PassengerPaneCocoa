#!/bin/bash

gem install passenger -y -q
/usr/bin/passenger-install-apache2-module -a

exit 0;