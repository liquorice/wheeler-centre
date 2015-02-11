# Wheeler Centre

Rails + Heracles app for the Wheeler Centre

# Development

### First-time setup

Check out the app :

    $ git clone git@bitbucket.org:icelab/wheeler-centre.git
    $ cd ~/src/wheeler-centre

To install the required gems & prepare the database:

    $ bin/setup

May also need to run the database migration in the process:

    rake db:migrate

Add the heroku git remote:

    git remote add heroku git@heroku.com:wheeler-centre.git

You can pull production data down using the following commands:

```
heroku pgbackups:capture --expire
wget `heroku pgbackups:url` -O dump.sql
pg_restore --verbose --clean --no-acl --no-owner -h localhost -d wheeler_centre_development < dump.sql
rm dump.sql
```

### Running the Application Locally

    $ foreman start -f Procfile.dev
    $ open http://localhost:5000

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
* `FASTLY_API_KEY`, `FASTLY_SERVICE_ID`  - API keys for integration with Fastly CDN.
* `CDN_ORIGIN_DOMAIN`, `CDN_ORIGIN_PORT` - i.e. the non-CDN-ed URL (and port)

## Assets

Assets are compiled outside of Sprockets (with the exception of Heracles admin assets). The main tasks are specified in our `Makefile`.

```
# Compile all the targets into `lib/src/tmp`
make dev
# Run `make dev`, and then generate a Rails-compatible manifest that’s merged
# with any sprockets-compiled assets
make build
# Spin up the local server/proxy server to serve development files
make serve
# Watch the targets directory and call `make dev` whenever things change
make watch
```

You should put your assets in `lib/src/targets` as build targets are _inferred_ from their directory names. Thus a folder structure like:

```
lib/
  src/
    targets/
      public/
        navigation/
          index.js
          index.css
        index.js
        index.css
      admin/
        index.js
```

Will produce the following build targets:

```
public.js
public.css
admin.js
```

We’re using [Duo](http://duojs.org/) to build the assets, which means you can use CommonJS syntax to `require` dependencies throughout your JavaScript, and `@import` directives to require dependencies throughout your CSS. In the structure above, we could `require` or `@import` the `navigation` component into the `public/index.css/js` files thusly:

```
// JS
var navigation = require('./navigation');

/* CSS */
@import './navigation';
```

JavaScript files will be processed through a JSX compiler and minified in production. CSS files are processed through [myth](https://github.com/segmentio/myth) in lieu of Sass.

### Development

In development, `foreman` will take care of booting the watcher and building your files as long as you’re booting it using the `Procfile.dev` command above. It will also spin up the `make serve` server that will serve your generated assets out of `/lib/src/tmp` over `localhost:1234`. To ensure it works with existing Rails assets (like the Heracles admin) that server will proxy through to the Rails application at `localhost:5000` for any assets that are not in that `tmp/` directory.

We’re using Rails’ standard support for custom assets hosts in development, so you’ll need to make sure this `ENV` variable is set correctly:

```
ASSET_HOST_DEVELOPMENT=localhost:1234
```

### Production

Assets should compile in production as you’d expect for any other sprockets-like Rails app. We do some overloading of the `rake assets:precompile` task to ensure that our generated assets are properly served.

#### Buildpacks

In production, we rely on `node` to build our assets, so we need a multi-buildpack setup. If you’re setting up a new app you’ll need to ensure that this custom buildpack is set:

```
heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
```
