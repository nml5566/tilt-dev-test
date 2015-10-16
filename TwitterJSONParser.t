#!/usr/bin/env perl

use strict;
use Test::More tests => 2;
use TwitterJSONParser;

my $jsonTweetString = <<'JSON';
{
  "statuses": [
    { 
      "metadata" : 
      { 
	"iso_language_code":"en","result_type":"recent"
      },
      "created_at" : "Tue Sep 22 19:07:26 +0000 2015",
      "id" : 646400430461857792,
      "id_str" : "646400430461857792",
      "text" : "@noradio Looks more like \"checking for a pulse\"."
    }
  ]
}
JSON

my $jsonUserString = <<'JSON';
[
  {
    "name": "Twitter API",
    "profile_sidebar_fill_color": "DDEEF6",
    "profile_background_tile": false,
    "profile_sidebar_border_color": "C0DEED",
    "profile_image_url": "http://a0.twimg.com/profile_images/2284174872/7df3h38zabcvjylnyfe3_normal.png",
    "location": "San Francisco, CA",
    "created_at": "Wed May 23 06:01:13 +0000 2007",
    "follow_request_sent": false,
    "id_str": "6253282",
    "profile_link_color": "0084B4",
    "is_translator": false,
    "default_profile": true,
    "favourites_count": 24,
    "contributors_enabled": true,
    "url": "http://dev.twitter.com",
    "profile_image_url_https": "https://si0.twimg.com/profile_images/2284174872/7df3h38zabcvjylnyfe3_normal.png",
    "utc_offset": -28800,
    "id": 6253282,
    "profile_use_background_image": true,
    "listed_count": 10713,
    "profile_text_color": "333333",
    "lang": "en",
    "followers_count": 1198334,
    "protected": false,
    "profile_background_image_url_https": "https://si0.twimg.com/images/themes/theme1/bg.png",
    "geo_enabled": true,
    "description": "The Real Twitter API. I tweet about API changes, service issues and happily answer questions about Twitter and our API. Don't get an answer? It's on my website.",
    "profile_background_color": "C0DEED",
    "verified": true,
    "notifications": false,
    "time_zone": "Pacific Time (US & Canada)",
    "statuses_count": 3331,
    "status": {
      "coordinates": null,
      "created_at": "Fri Aug 24 16:15:49 +0000 2012",
      "favorited": false,
      "truncated": false,
      "id_str": "239033279343382529",
      "in_reply_to_user_id_str": "134727529",
      "text": "@gregclermont no, there is not. ^TS",
      "contributors": null,
      "retweet_count": 0,
      "id": 239033279343382529,
      "in_reply_to_status_id_str": "238933943146131456",
      "geo": null,
      "retweeted": false,
      "in_reply_to_user_id": 134727529,
      "place": null,
      "in_reply_to_screen_name": "gregclermont",
      "in_reply_to_status_id": 238933943146131456
    },
    "profile_background_image_url": "http://a0.twimg.com/images/themes/theme1/bg.png",
    "default_profile_image": false,
    "friends_count": 31,
    "screen_name": "twitterapi",
    "following": true,
    "show_all_inline_media": false
  },
  {
    "name": "Twitter",
    "profile_sidebar_fill_color": "F6F6F6",
    "profile_background_tile": true,
    "profile_sidebar_border_color": "EEEEEE",
    "profile_image_url": "http://a0.twimg.com/profile_images/2284174758/v65oai7fxn47qv9nectx_normal.png",
    "location": "San Francisco, CA",
    "created_at": "Tue Feb 20 14:35:54 +0000 2007",
    "follow_request_sent": false,
    "id_str": "783214",
    "profile_link_color": "038543",
    "is_translator": false,
    "default_profile": false,
    "favourites_count": 17,
    "contributors_enabled": true,
    "url": "http://blog.twitter.com/",
    "profile_image_url_https": "https://si0.twimg.com/profile_images/2284174758/v65oai7fxn47qv9nectx_normal.png",
    "utc_offset": -28800,
    "id": 783214,
    "profile_banner_url": "https://si0.twimg.com/brand_banners/twitter/1323368512/live",
    "profile_use_background_image": true,
    "listed_count": 72534,
    "profile_text_color": "333333",
    "lang": "en",
    "followers_count": 12788713,
    "protected": false,
    "profile_background_image_url_https": "https://si0.twimg.com/profile_background_images/378245879/Twitter_1544x2000.png",
    "geo_enabled": true,
    "description": "Always wondering what's happening. ",
    "profile_background_color": "ACDED6",
    "verified": true,
    "notifications": false,
    "time_zone": "Pacific Time (US & Canada)",
    "statuses_count": 1379,
    "status": {
      "coordinates": null,
      "created_at": "Tue Aug 21 19:04:00 +0000 2012",
      "favorited": false,
      "truncated": false,
      "id_str": "237988442338897920",
      "retweeted_status": {
        "coordinates": null,
        "created_at": "Tue Aug 21 18:51:44 +0000 2012",
        "favorited": false,
        "truncated": false,
        "id_str": "237985351858278400",
        "in_reply_to_user_id_str": null,
        "text": "Arijit Guha fought for insurance coverage, and won.\n http://t.co/ZvQ6fU2O #twitterstories http://t.co/bVYPNnV7",
        "contributors": [
          16896060
        ],
        "retweet_count": 118,
        "id": 237985351858278400,
        "in_reply_to_status_id_str": null,
        "geo": null,
        "retweeted": false,
        "possibly_sensitive": false,
        "in_reply_to_user_id": null,
        "place": null,
        "source": "web",
        "in_reply_to_screen_name": null,
        "in_reply_to_status_id": null
      },
      "in_reply_to_user_id_str": null,
      "text": "RT @TwitterStories: Arijit Guha fought for insurance coverage, and won.\n http://t.co/ZvQ6fU2O #twitterstories http://t.co/bVYPNnV7",
      "contributors": null,
      "retweet_count": 118,
      "id": 237988442338897920,
      "in_reply_to_status_id_str": null,
      "geo": null,
      "retweeted": false,
      "possibly_sensitive": false,
      "in_reply_to_user_id": null,
      "place": null,
      "source": "web",
      "in_reply_to_screen_name": null,
      "in_reply_to_status_id": null
    },
    "profile_background_image_url": "http://a0.twimg.com/profile_background_images/378245879/Twitter_1544x2000.png",
    "default_profile_image": false,
    "friends_count": 1195,
    "screen_name": "twitter",
    "following": true,
    "show_all_inline_media": true
  }
]
JSON

my $parser = TwitterJSONParser->new();
my @texts = $parser->getTextsFromTweetJSON($jsonTweetString);

is(scalar(@texts), 1, 
  "Gets expected number of texts from tweet JSON");

my @names = $parser->getScreenNamesFromUserJSON($jsonUserString);
is($names[0], "twitterapi", 
  "Gets expected screen names from user JSON");
