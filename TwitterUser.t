#!/usr/bin/env perl

use strict;
use Test::More tests => 3;
use TwitterUser;

my $validUser = TwitterUser->new('@validUser');
my $invalidUser = TwitterUser->new('invalidUser');


is($invalidUser->hasValidName(), 0, 
  "Invalid user returns false"
);

is($validUser->hasValidName(), 1, 
  "Valid user returns true"
);

is($validUser->screenName(), "validUser", 
  "Valid user screen name is name without ampersand symbol"
);
