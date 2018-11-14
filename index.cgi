#!/usr/bin/perl -w

use strict;
use warnings;

use lib '/home/www/api.alternote.org/modules';
use lib '/home/www/api.alternote.org/lib';

use Mojolicious::Commands;

# Start command line interface for application
Mojolicious::Commands->start_app('MyApp');