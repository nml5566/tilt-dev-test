#!/usr/bin/env perl
use strict;
use Test::More tests => 4;
use TiltDevTest;

my @userIds = map $_, (1..203);

# ID => Screen Name lookups accept 100 users max per request. 
# This sub will chunk those requests appropriately
my @params = TiltDevTest::convertUserIdArrayToUserLookupParamRequest(@userIds);

is(scalar(@params), 3, 
  "Converts array of user Ids to valid param request");

is(scalar(split(',', $params[0]{'user_id'})), 100, 
  "1st param request elements has 100 agents");

is(scalar(split(',', $params[1]{'user_id'})), 100, 
  "2st param request elements has 100 agent");

is(scalar(split(',', $params[2]{'user_id'})), 3, 
  "3rd param request elements has 3 agent");
