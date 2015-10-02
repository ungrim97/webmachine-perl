#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use MyApp;

use Plack::Builder;

builder {
    mount '/' => MyApp->as_app;
};
