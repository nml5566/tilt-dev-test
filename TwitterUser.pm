package TwitterUser;
use TiltDevTest;
use TwitterJSONParser;

my $BROWSER  = LWP::UserAgent->new();
my $PARSER  = TwitterJSONParser->getInstance();

sub new
{
  my $self = shift;
  my $name = shift;
  return bless { "name" => $name }, $self;
}

sub name { return shift->{'name'}; }

sub hasValidName
{
  my $self = shift;

  my $bool = 0;
  $bool = 1 if ($self->name() =~ /^@[A-Za-z0-9_]{1,15}$/);
  
  return $bool;
}

sub getFollowerIds()
{
  my $self = shift;

  my $api = TwitterAPI::getInstance();

  my %params = ( 'screen_name' => $self->screenName() );
  my $jsonFollowerString = $api->getUserFollowersJSON(%params);

  my @ids = $PARSER->getIdsFromFollowerJSON($jsonFollowerString);

  return @ids;
}

sub screenName()
{
  my $self = shift;
  return substr $self->name(), 1;
}

sub getTweets()
{
  my $self = shift;

  my $api = TwitterAPI::getInstance();
  my %params = ( 'q' => $self->name() );
  my $jsonTweetString = $api->getUserTweetJSON(%params);
  my @texts = $PARSER->getTextsFromTweetJSON($jsonTweetString);

  return @texts;
}

1;
