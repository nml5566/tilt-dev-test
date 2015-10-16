# ABOUT
This is the internal documentation for getting the Tilt Dev test
up-and-running. Refer to the installation section for dependencies and how to
install them. This guide assumes the user is running Ubuntu 14.04 on an Amazon
Web Services EC2 instance. You'll need to refer to outside documentation for
tweaking on other operation systems.

# INSTALLATION

## Build Environment

The build enviroment is required to compile additional packages. 

It can be installed with the following command:

  `sudo apt-get install build-essential`

## Perl Modules

LWP::UserAgent is required to access the Twitter API. LWP::Protocol::https is
needed to access secure URLs

First libssl must be installed:

  `sudo apt-get install libssl-dev`

Below are the commands to install the Perl modules:

```
  sudo perl -MCPAN -e shell
  cpan> install LWP::UserAgent
  cpan> install LWP::Protocol::https:
```

## Apache2

Apache is required to serve the Tilt webapp. 

First install apache:
  
  `sudo apt-get install apache2`

Next enable Apache's ability to run CGI scripts

```
  cd /etc/apache2/mods-enabled
  sudo ln -s ../mods-available/cgi.load .
```

Copy the tilt.conf in this folder to /etc/apache2/sites-enabled

  `cp tilt.conf /etc/apache2/sites-enabled/`

Copy the Perl modules and their associated cgi script into the webroot
 
  `cp *.{pm,pl} /var/www/html`

Then give Apache permissions on the CGI script

```
  chown www-data /var/www/html/index.pl
  chmod u+x /var/www/html/index.pl
```

Finally start Apache2

  `sudo service apache2 start`

If everything worked, you should see the app welcome screen when you go to
your server IP address in your browser.

## Behavior Testing Suite

The following packages are needed to run integration tests on the API via the web.

Node 4.10 
The commands below are taken from this link:

  https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions

```
  curl --silent --location https://deb.nodesource.com/setup_4.x | sudo bash -
  sudo apt-get install --yes nodejs
```
  
ZombieJS (https://github.com/assaf/zombie)

  `npm install -g zombie --save-dev`

MochaJS (http://mochajs.org/)

  `sudo npm install -g mocha`

# TESTING
Make sure to follow the installation section before attempting to run tests

To run unit tests on the Perl modules

  `prove *.t`

To run integration testing:

  `mocha zombie.js -t 10s`

