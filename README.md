# Wheeler Centre

Rails + Heracles app for the Wheeler Centre

# Development

### First-time setup

Ensure you have access Icelab's [Gemfury](http://fury.io) organization. Log in and visit the [repos page](https://manage.fury.io/dashboard/icelab#/repos) to find your private repo token (it's listed at the top of the page as `https://your-token-here@repo.fury.io/icelab/`). Let bundler know about your token:

```
bundle config https://gem.fury.io/icelab/ put-your-token-here
```

Then check out the app:

```
git clone git@github.com:icelab/wheeler-centre.git
cd ~/src/wheeler-centre
```

To set up all the required services:

```
bin/boostrap
```

Once that’s done you can start the services by running:

```
bin/services
```

You’ll need to have them running for any of the following commands.

Install the required gems & prepare the database:

```
bin/setup
```

May also need to run the database migration in the process:

```
rake db:migrate
```

Add the heroku git remote:

```
git remote add heroku git@heroku.com:wheeler-centre.git
```

You can pull production data down using the following commands:

```
heroku pg:backups capture --app=wheeler-centre
curl -o latest.dump `heroku pg:backups --app=wheeler-centre public-url`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -p 5432 -d wheeler_centre_development < ./latest.dump
rm latest.dump
```

The database username/password in development are both `db`.

### Running the Application Locally

```
foreman start -f Procfile.dev
open http://localhost:5000
```

### Running the Specs

To run all ruby and javascript specs:

```
rake
```

Again, with coverage for the ruby specs:

```
rake spec:coverage
```

### Using Guard

Guard is configured to run ruby and jasmine specs, and also listen for
livereload connections. Growl is used for notifications.

```
guard
```

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
* `CDN_ORIGIN_DOMAIN`, `CDN_ORIGIN_PORT` - i.e. the non-CDN-ed URL (and port)
* `FOG_PROVIDER` - Required for the fog gem, in our case this will generally be AWS and is used to generate the search engine sitemaps.

### Assets

Assets live outside the standard sprockets-based asset pipeline. We’re using webpack to (almost) entirely replace the asset pipeline, though it works in a similar way to the asset pipeline in practice: we’re not creating fancy bundles, just normal static JavaScript and CSS.

Assets live in `./assets/targets`. Creating a folder there will create a named target that matches. This:

```
./assets/targets/public —> public.js, public.css
```

To add a new target, you can use the `asset_target` generator:

```
rails generate asset_target target-name
```

This would generate the following files:

```
./assets/targets
  /target-name
    - target.js        # Configuration file, sets up our target output
    - index.css        # Base CSS file, where your CSS originates from
    - index.js         # Base JS file, where your JS originates from
```

Asset tasks are run using npm. They’re listed in the `package.json` in the `scripts` block. The main scripts are:

```
npm run start
```

This will spin up the webpack development-server. In development we send all asset requests through this server by setting a custom `asset_host` in `development.rb`. The webpack development-server will attempt to proxy any requests it cannot fill back to the Rails apps, so any normal asset-pipeline requests should work.

```
npm run build
```

This will build a development version of the webpack assets into `./assets/build` so you can inspect them.

#### JavaScript

Dependencies are managed through [npm](http://npmjs.com). To add a dependency you’ll want to:

```
npm install --save my-new-dependency
```

This will add the dependency to the `package.json` (née `Gemfile`) in the root directory. If you do not include `--save` then your dependency will not be installed on deployment.

**Note**: We’re building assets on the fly for deployment and so any compilation process will need both the `devDependencies` and the `dependencies` hash in `package.json` to be installed. On Heroku this means [you’ll need to set a config variable](https://github.com/heroku/heroku-buildpack-nodejs#enable-or-disable-devdependencies-installation):

```
heroku config:set NPM_CONFIG_PRODUCTION=false
```

JavaScript is loaded using the CommonJS module pattern — the same as npm — which means each file is encapsulated (much like CoffeeScript). This also means *there is no shared scope*; each file must require dependencies to have access to them. This is done by calling `require("dependency-name")`.

CommonJS modules _should_ export a default object that gets returned as the value of a `require`. For example, if you want to use jQuery in one of your files you’ll need to explicitly require it like this (assuming you have it included in your `package.json`):

```js
var $ = require("jquery");
```

Local dependencies should follow the same pattern:

```js
// ./foo/index.js
var privateVariable = "foo";
function Foo() {
  console.log(privateVariable);
}
module.exports = Foo;

// ./index.js
var Foo = require("./foo"); // Will look for index.js automatically
var fooInstance = new Foo();
```

#### Debugging

We inject a special constant into the JavaScript environment at build time: `DEVELOPMENT`. This is a boolean that allows you to add *persistent* code you’d only like to run in development:

```js
if (DEVELOPMENT) {
  console.warn(obj.property);
}
```

^ This will `warn` in development, and *won’t even been compiled* into the production build.

# Deployment

The site runs on Heroku, behind a [Fastly](https://www.fastly.com) CDN.

Two buildpacks are used on Heroku: nodejs (for the assets) and ruby (for the main app). When setting up a new Heroku app, add them as follows:

```
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-nodejs
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-ruby
```

Add a Gemfury repo token config var so bundler on Heroku can install the private heracles gem:

```
heroku config:set BUNDLE_GEM__FURY__IO="your-token-here"
```

You can find the token on your [Gemfury repos page](https://manage.fury.io/dashboard/icelab#/repos).

## Dealing with Heroku review apps
```sh
heroku config:set ADMIN_HOST=wheeler-centre-pr-46.herokuapp.com CANONICAL_DOMAIN=https://wheeler-centre-pr-46.herokuapp.com CANONICAL_HOSTNAME=wheeler-centre-pr-46.herokuapp.com --app wheeler-centre-pr-46
heroku run rake temporary:setup_next_chapter --app wheeler-centre-pr-46
heroku run rake temporary:setup_new_notes --app wheeler-centre-pr-46
```
