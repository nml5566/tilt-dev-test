var http = require("http");
var Browser = require("zombie");
var assert = require('assert');

describe('User visiting Tilt dev test API page', function() 
{
  const browser = new Browser({site: 'http://localhost', debug : true});


  describe("who doesn't pass any GET parameters", function() 
  {
    before(function() { return browser.visit('/'); });

    it('should be greeted with hi', function(done) {
      //assert.equal(browser.text('body'), 'hi');
      done();
    });
  });

  describe("who passes a single valid user to the 'users=' GET parameter", 
    function() 
  {
    before(function() { return browser.visit('/?users=@noradio'); });

    it('receives a list of recent tweets', function(done) {
      var json = JSON.parse(browser.text('body'));

      var tweets = json.tweets;
      assert.notEqual(undefined, tweets);
      assert.equal(true, Array.isArray(tweets));
      assert.notEqual(0, tweets.length);

      done();
    });
  });

  describe("who passes two valid users to the 'users=' GET parameter", 
    function() 
  {
    before(function() { return browser.visit('/?users=@twitter,@twitterapi'); });

    it('receives a list of shared followers', function(done) {
      var json = JSON.parse(browser.text('body'));

      var followers = json.shared_followers;
      assert.equal(true, Array.isArray(followers));
      assert.notEqual(0, followers.length);

      done();
    });
  });

  describe("who passes an invalid user to the 'users=' GET parameter", function() 
  {
    before(function() { return browser.visit('/?users=twitter'); });

    it('receives an error message', function(done) {
      var json = JSON.parse(browser.text('body'));

      var error = json.error;
      assert.notEqual(undefined, error);

      done();
    });
  });

});
