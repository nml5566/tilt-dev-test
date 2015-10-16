#!/usr/bin/env perl
use strict;
use Test::More tests => 1;
use TwitterAPI;

my $key = "xvz1evFS4wEEPTGEFPHBog";
my $secret = "L8qq9PZyRg6ieKGEKhZolGC0vJWLw8iEJ88DRdyOg";

my $token = TwitterAPI::convertKeySecretComboToAuthToken($key, $secret);

my $expectedToken = 
  "eHZ6MWV2RlM0d0VFUFRHRUZQSEJvZzpMOHFxOVBaeVJnNmllS0dFS2hab2xHQzB2SldMdzhpRUo4OERSZHlPZw==";

is($token, $expectedToken, 
  "Converts twitter key/secret combo into encoded token");
