# Wheeler Centre

_Write a brief overview of the app here._

Primary developers:

* _Your name here_

# Development

### First-time setup

Check out the app with Boxen:

    $ boxen wheeler-centre
    $ cd ~/src/wheeler-centre

To install the required gems & prepare the database:

    $ bin/setup

Run `rake db:sample_data` to load a small set of data for development. See
`db/sample_data.rb` for details.

### Running the Application Locally

    $ foreman start
    $ open http://localhost:3000

### Running the Specs

To run all ruby and javascript specs:

    $ rake

Again, with coverage for the ruby specs:

    $ rake spec:coverage

### Using Guard

Guard is configured to run ruby and jasmine specs, and also listen for
livereload connections. Growl is used for notifications.

    $ guard

### Environment Variables

Several common features and operational parameters can be set using
environment variables. These are all optional.

* `SECRET_KEY_BASE` - Secret key base for verfying signed cookies. Should be
  30+ random characters and secret!
* `HOSTNAME` - Canonical hostname for this application. Other incoming
  requests will be redirected to this hostname.
* `BASIC_AUTH_PASSWORD` - Enable basic auth with this password.
* `BASIC_AUTH_USER` - Set a basic auth username (not required, password
  enables basic auth).
* `UNICORN_WORKERS` - Number of unicorn workers to spawn (default: development
  1, otherwisee 3) .
* `UNICORN_BACKLOG` - Depth of unicorn backlog (default: 16).
* `BUGSNAG_API_KEY` - API key for tracking errors with Bugsnag.
* `ASSETS_AWS_REGION`, `ASSETS_AWS_BUCKET`, `ASSETS_AWS_ACCESS_KEY_ID`,
  `ASSETS_AWS_SECRET_ACCESS_KEY` - S3 configuration for syncing Rails asset
  pipeline files when deploying/precompiling.
