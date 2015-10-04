#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use MyApp;

use Plack::Builder;

builder {
    enable 'Debug';
    mount '/' => MyApp->as_app;
};
