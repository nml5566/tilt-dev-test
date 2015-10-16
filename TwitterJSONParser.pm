package TwitterJSONParser;
use strict;
use JSON::PP;

my $INSTANCE = undef;

sub getInstance
{
  $INSTANCE = TwitterJSONParser->new() if ($INSTANCE == undef);
  return $INSTANCE;
}

sub new 
{
  my $self = shift;

  return bless 
  {
    'errors' => undef
  }
}

sub errors { return defined shift->{'errors'}; }
sub errorMessage 
{ 
  my $self = shift;
  my $additionalInfo = shift;

  my $hash =  
  { 
    "error" => $additionalInfo, 
    "twitter_response" => $self->{'errors'} 
  }; 
  return encode_json $hash;
}

sub invalidUserErrorJSON
{
  my $hash =  { "error" => "Invalid username. Please check your spelling." };
  return encode_json $hash;
}

sub getTextsFromTweetJSON
{
  my $self = shift;
  my $jsonString = shift;

  my $tweetHash = decode_json $jsonString;

  my $statuses = $tweetHash->{'statuses'};

  my @texts;

  for my $status (@$statuses)
  {
    push @texts, $status->{'text'};
  }

  return @texts;
}

sub getIdsFromFollowerJSON
{
  my $self = shift;
  my $jsonString = shift;

  my $followerHash = decode_json $jsonString;

  my @ids;

  my $errors = $followerHash->{'errors'};
  if ($errors) {
    $self->{'errors'} = $errors;
  }
  else {
    @ids = @{$followerHash->{'ids'}};
  }

  return @ids;
}

sub encodeArrayOfTweetsToTiltJSON
{
  my @tweets = @_;
  my $outputHash =  { "tweets" => \@tweets };
  my $outputJSONString = encode_json $outputHash;
  return $outputJSONString;
}

sub encodeArrayOfFollowersToTiltJSON
{
  my @followers = @_;
  my $followersHash =  { "shared_followers" => \@followers };
  my $followersJSONString = encode_json $followersHash;
  return $followersJSONString;
}

sub getAccessTokenFromAuthJSON
{
  my $self = shift;
  my $jsonString = shift;
  my $authHash = decode_json $jsonString;

  die "Invalid token type" unless ($authHash->{'token_type'} == "bearer");

  my $accessToken = $authHash->{'access_token'};
  return $accessToken;
}

sub getScreenNamesFromUserJSON
{
  my $self = shift;
  my $jsonString = shift;

  my $userArray = decode_json $jsonString;

  my @screenNames;

  my $errors = (ref($userArray) eq "HASH") ? $userArray->{'errors'} : undef;

  if ($errors) { $self->{'errors'} = $errors; }

  else {
    for my $user (@$userArray)
    {
      push @screenNames, $user->{'screen_name'}; 
    }
  }

  return @screenNames;
}

1;
