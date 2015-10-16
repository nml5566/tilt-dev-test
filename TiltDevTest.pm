use strict;

package TiltDevTest;
use CGI;
use CGI::Carp qw/fatalsToBrowser/; 
use TwitterAPI;
use TwitterUser;
use TwitterJSONParser;

my $CGI = CGI->new();
my $PARSER  = TwitterJSONParser->getInstance();

sub run 
{
  ## return JSON string

  my $usersParam = $CGI->param('users');

  my @users = split(',', $usersParam);
  my $userCount = scalar(@users);

  if ($userCount)
  {
    print $CGI->header(-type => "application/json", -charset => "utf-8");

    if ($userCount == 1)
    {
      printTweetTextsFromUser($users[0]);
    } 
    else
    {
      printFollowersSharedBetweenUsers(@users);
    } 
  }
  else 
  {
    print $CGI->header(-type => "text/html", -charset => "utf-8");

    my $html = <<'HTML';
<h1>Welcome to the Tilt dev test API application documentation</h1>
<hr>
This application is capable of doing the following:
<ul>
<li>
  <p>Given a twitter username, return the user's most recent tweets</p>
  <p><a href="/?users=@twitter">Example tweet query</a></p>
</li>
<li>
  <p>Given 2+ twitter usernames, return the intersection of the users that both 
     given users follow</p>
  <p><a href="/?users=@twitter,@twitterapi">Example shared followers query</a></p>
</li>
</ul>
<p>
  You can use the app by passing a comma-separated list of twitter handles to the 
  "users=" GET request in the url field like so:
</p>
<p>
  <pre>
  http://ec2-52-26-48-122.us-west-2.compute.amazonaws.com/<b><u>?users=@user1,@user2</u></b>
  </pre>
</p>
<p>
  Some things to keep in mind:
  <ul>
  <li>Only valid twitter handles (including the @ symbol) are accepted. 
  Invalid handles will return an error.</li> 
  <li>There is a rate request limit for using the Twitter API.
     Rates exceeding this request will result in an error.
  </li>
</p>

HTML

    print $html;
  }
}

sub printTweetTextsFromUser
{
  my $userName = shift;

  my $user = TwitterUser->new($userName);

  return print TwitterJSONParser::invalidUserErrorJSON() 
    unless $user->hasValidName();

  my @tweets = $user->getTweets();
  print TwitterJSONParser::encodeArrayOfTweetsToTiltJSON(@tweets);
}

sub printFollowersSharedBetweenUsers
{
  my @userNames = @_;

  my @sharedFollowerIds;
  my %seen;

  for my $userName (@userNames) 
  {
    my $user = TwitterUser->new($userName);

    return print TwitterJSONParser::invalidUserErrorJSON() 
      unless $user->hasValidName();

    my @followerIds = $user->getFollowerIds();
    return print
      $PARSER->errorMessage("Unable to get followers for " . $user->name()) 
      if $PARSER->errors();


    for my $id (@followerIds)
    {
      $seen{$id}++;  
    }
  }

  while (my ($k,$v) = each %seen)
  {
    if ($v == scalar(@userNames))
    {
      push @sharedFollowerIds, $k;
    }
  }

  my @params = convertUserIdArrayToUserLookupParamRequest(@sharedFollowerIds);

  my @sharedFollowerNames;
  my $api = TwitterAPI::getInstance();

  for my $param (@params)
  {
    push @sharedFollowerNames, $api->convertUserIdsToNames(%$param);
    return print $PARSER->errorMessage("Unable to get user screen names") 
      if $PARSER->errors();
  }

  print TwitterJSONParser::encodeArrayOfFollowersToTiltJSON(@sharedFollowerNames);
}

sub convertUserIdArrayToUserLookupParamRequest
{
  my @userIds = @_;

  my $userString = join(',', map $_, (1..100));
  my @params;

  while (scalar(@userIds))
  {
    my @elements = getNext100ElementsFromArray(\@userIds);
    my $string = join(",", @elements);
    push @params, {'user_id' => $string} 
  }

  return @params;
}

sub getNext100ElementsFromArray
{
  my $array = shift;
  my $arrayLength = scalar(@$array);
  my $max =  ($arrayLength > 99) ? 99 : ($arrayLength-1);

  my @elements;
  map { push @elements, shift @$array } (0..$max);
}

1;
