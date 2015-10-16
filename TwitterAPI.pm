package TwitterAPI;
use strict;
use CGI;
use LWP::UserAgent;
use JSON::PP;
use MIME::Base64;
use TwitterJSONParser;

my $INSTANCE = undef;
my $HOST = "api.twitter.com";
my $BASE_URL = "https://$HOST";
my $USER_AGENT = 'Tilt Dev Test Twitter API Application-only OAuth App v.1';

my $CGI = CGI->new();
my $BROWSER  = LWP::UserAgent->new();
my $PARSER  = TwitterJSONParser->getInstance();

sub getInstance()
{
  $INSTANCE = TwitterAPI->new() if ($INSTANCE == undef);
  return $INSTANCE;
}

sub new 
{
  my $self = shift;

  my $bearerToken = getBearerToken();
  my $accessToken = getAccessTokenFromBearerToken($bearerToken);

  return bless 
  {
    'bearer_token' => $bearerToken,
    'access_token' => $accessToken
  }, $self;
}

sub getBearerToken
{
  my $consumerKey = "INSERT KEY HERE";
  my $consumerSecret = "INSERT SECRET HERE";

  my $base64EncodedBearerToken = 
    convertKeySecretComboToAuthToken($consumerKey, $consumerSecret);
  
  return $base64EncodedBearerToken;
}

sub convertKeySecretComboToAuthToken
{
  my ($key, $secret) = @_;

  my $encodedConsumerKey = $CGI->escape($key);
  my $encodedConsumerSecret = $CGI->escape($secret);

  my $bearerToken = "$encodedConsumerKey:$encodedConsumerSecret";
  # Encoding will insert newlines after 76 charactes unless end-of line is blank
  my $eol = "";
  my $base64EncodedBearerToken = encode_base64($bearerToken, $eol);
  return $base64EncodedBearerToken;
}

sub getAccessTokenFromBearerToken
{
  my $base64EncodedBearerToken = shift;
  my $authURL = "$BASE_URL/oauth2/token";

  my $authHeaders = 
  { 
    'Host' => $HOST,
    'User-Agent' => $USER_AGENT,
    'Authorization' => "Basic $base64EncodedBearerToken",
    'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8',
    'Accept-Encoding' => 'gzip',
    'Content' => ['grant_type' =>  "client_credentials"]
  };

  my $authResponse = $BROWSER->post( $authURL, %$authHeaders);

  my $jsonString  = $authResponse->decoded_content();
  my $accessToken = $PARSER->getAccessTokenFromAuthJSON($jsonString);

  return $accessToken;
}

sub getUserTweetJSON
{
  my $self = shift;
  my %params = @_;

  my $accessToken = $self->{'access_token'};

  my $getTweetHeaders = 
  {
    'Host' => $HOST,
    'User-Agent' => $USER_AGENT,
    'Authorization' => "Bearer $accessToken",
    'Accept-Encoding' => 'gzip'
  };

  my $getTweetURL = URI->new($BASE_URL . "/1.1/search/tweets.json");

  $getTweetURL->query_form(%params);

  my $tweetResponse = $BROWSER->get($getTweetURL, %$getTweetHeaders);

  my $jsonTweetString  = $tweetResponse->decoded_content();
  return $jsonTweetString;
}

sub getUserFollowersJSON
{
  my $self = shift;
  my %params = @_;

  my $accessToken = $self->{'access_token'};

  my $getFollowersHeaders = 
  {
    'Host' => $HOST,
    'User-Agent' => $USER_AGENT,
    'Authorization' => "Bearer $accessToken",
    'Accept-Encoding' => 'gzip'
  };

  my $getFollowersURL = URI->new(
    $BASE_URL . "/1.1/followers/ids.json"
  );

  $getFollowersURL->query_form(%params);

  my $followerResponse = $BROWSER->get($getFollowersURL, %$getFollowersHeaders);

  my $jsonFollowerString  = $followerResponse->decoded_content();
  return $jsonFollowerString;
}

sub convertUserIdsToNames()
{
  my $self = shift;
  my %params = @_;

  my $userIdString = $params{'user_id'};
  die "No user id specified" unless $userIdString;

  die "Can only convert up to 100 ids per request" if 
    scalar(split(',', $userIdString)) > 100;

  my $accessToken = $self->{'access_token'};

  my $getUsersHeaders = 
  {
    'Host' => $HOST,
    'User-Agent' => $USER_AGENT,
    'Authorization' => "Bearer $accessToken",
    'Accept-Encoding' => 'gzip'
  };

  my $getUsersURL = URI->new("$BASE_URL/1.1/users/lookup.json");

  $getUsersURL->query_form(%params);

  my $userResponse = $BROWSER->get($getUsersURL, %$getUsersHeaders);

  my $jsonUserString  = $userResponse->decoded_content();
  my @names = $PARSER->getScreenNamesFromUserJSON($jsonUserString);

  return @names;
}
