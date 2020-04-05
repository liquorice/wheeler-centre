# Heracles

Flexible CMS engines for Rails applications.

# Setup

### Installing the private gem

Heracles is available as a private gem via Icelab's Icelab's [Gemfury](http://fury.io) organization. Add it to your `Gemfile` as follows:

```
gem "icelab-heracles", "~> 2.0.0.beta67", source: "https://gem.fury.io/icelab/", require: "heracles"
```

To ensure you can install the gem, log in and visit the [Gemfury repos page](https://manage.fury.io/dashboard/icelab#/repos) and find your private repo token (it's listed at the top of the page as `https://your-token-here@repo.fury.io/icelab/`). Let bundler know about your token:

```
bundle config https://gem.fury.io/icelab/ put-your-token-here
```

After this, running `bundle` will install the private gem.

### Installing migrations

You need the Heracles tables to be present for the engines to function.

```sh
rake heracles:install:migrations
rake db:migrate
```

### Enabling the admin area

Only the Heracles core engine is activated when you load the gem.

If you need the admin area, load it in `application.rb`:

```ruby
require "heracles-admin"
```

And mount the engine in `routes.rb`:

```ruby
YourApp::Application.routes.draw do
  mount Heracles::Admin::Engine, at: "/admin"
end
```

#### Configuring the admin area

You must set an `heracles_admin_host` Rails config value if you want to access
the admin area at the "/admin" URL path. Do this in `application.rb` or an
initializer:

```ruby
Heracles.configure do |config|
  config.admin_host = "localhost" # or e.g. ENV["HERACLES_ADMIN_HOST"]
end
```

When deploying the app to production, be sure that this value matches the
running production app's hostname.

You’ll also need an API key for [Embedly](http://embed.ly/), a service we use for handling rich embeds:

```ruby
Heracles.configure do |config|
  config.embedly_api_key = "xxx" # or e.g. ENV["EMBEDLY_API_KEY"]
end
```

You should use `ENV` variables to keep these configuration values out of version control. [dotenv](https://github.com/bkeepers/dotenv) is useful for doing this during local development.

#### Enabling built-in admin user authentication and management

The admin area's user authentication is fully configurable (see below for more detail). However, if you want user authentication and management to be provided for you, then enable this extra engine in `application.rb`:

```
require "heracles-admin-user-auth"
```

This engine provides an `Heracles::User` model for the admin users, and an `Heracles::SiteAdministration` model for associating ordinary admins (i.e. non-superadmins) to sites.

#### Customizing admin user authentication

If you want your app to provide its own admin users, don't activate the "heracles-admin-user-auth" engine as above, and instead, do the following.

Specify two classes, for your users, and user-to-site associations. Do this in an initializer:

```ruby
Heracles.user_class = "User"
Heracles.site_administration_class = "SiteAdministration"
```

The user class must provide the following methods:

* `#heracles_admin?` - true if the user should be able to log into the admin area at all
* `#heracles_superadmin?` - true if the user should have access to the advanced sections of the admin area
* `#heracles_admin_name` - a string that represents the user's name (e.g. an email address), for showing the current user in the admin area.

The site administration class must provide the following methods:

* `.sites_administerable_by(user)` - an `ActiveRecord::Relation` for `Heracles::Site` containing the sites that the provided user is allowed to administer.

Your app should also provide a controller for signing users in and out, as well as a controller helper method for accessing the current user. Create a `lib/heracles_admin_authentication_helpers.rb` file to specify these to the admin engine:

```ruby
module HeraclesAdminAuthenticationHelpers
  def self.included(base)
    base.send :helper_method, :heracles_admin_login_path
    base.send :helper_method, :heracles_admin_logout_path
    base.send :helper_method, :heracles_admin_logout_path_method
    base.send :helper_method, :heracles_admin_current_user
  end

  def heracles_admin_current_user
    current_user
  end

  def heracles_admin_login_path
    main_app.login_path
  end

  def heracles_admin_logout_path
    main_app.logout_path
  end

  def heracles_admin_logout_path_method
    :delete
  end
end

Heracles::Admin::ApplicationController.send :include, HeraclesAdminAuthenticationHelpers
```

All parts of this file are required. Adjust them as you see fit. In the same initializer as above, require this file (at the appropriate stage during the app boot):

```ruby
Rails.application.config.to_prepare do
  require_dependency "heracles_admin_authentication_helpers"
end
```

### Configuring asset processors

TODO

To use an asset processor for image insertables, specify it on the site's `render_content_defaults`:

```ruby
Heracles::Sites::MySite.configure do |config|
  config.render_content_defaults = {
    image: {
      asset_processor: :cloudinary,
      asset_processor_options: {
        preset: :content_large # replace this with your own preset
      }
    }
  }
end
```

### Configuring the devise mailer sender

To configure the devise mail sender address used for password resets, set
the `heracles_mailer_sender` config value in each of your Rails environments.

For example:

```ruby
# config/environments/production.rb
Rails.application.configure do
  config.heracles_mailer_sender = "no-reply@example.com"
end
```

If this value is not set, a default of `support@unimelb.edu.au` is used.

### Serving multiple sites

To serve multiple sites from the one application, enable it in `application.rb`:

```ruby
require "heracles-public-site-manager"
```

And mount the engine in `routes.rb`:

```ruby
YourApp::Application.routes.draw do
  mount Heracles::PublicSiteManager::Engine, at: "/"
end
```

# Working within your app

### Creating site engines

When Heracles is configured to serve multiple sites, create a new site engine
using the Rails generator:

```
rails generate site site_name
```

# Deployment

You can find the token on your [Gemfury repos page](https://manage.fury.io/dashboard/icelab#/repos).

# Architecture

## Overview

Heracles is a centralised, hosted CMS initially built for the University of
Melbourne.

It is a single codebase that can serve multiple **sites** at once. Each site
consists of a tree of **pages**. Pages consist of many **fields**, for holding
their content.

## Sites

Sites are independently configurable. This allows for each site to have their
own flexible, distinct structure and functionality. Sites also provide their own bundle of page templates and Ruby code.

Each site runs on its own hostname.

### Site engines

Each site is a mountable Rails engine. Like any engine, it can provide its own
models, controllers, view templates, static assets, routes and other
configuration.

These engines are included directly in the main codebase, in the `sites`
directory.

See the "Advanced site engine techniques" section below for more information
about working with site engines.

## Pages

Pages belong to a site & are stored in the database in a tree structure. Each
page record has these basic attributes:

* An ID: instead of a conventional auto-incrementing ID column, pages have
  _semantic IDs_, based on their URL within their site. This ID will be used to
  look up the appropriate page record for a public request.
* A slug: the page's identifier within its level in the tree.
* A type: connects the page to a Ruby class, so custom behaviour can be given to
  particular pages.
* JSON-serialized fields data: the contents of all the fields on the page.

The tree of pages is open for site publishers to modify at any point, via the
admin area. Publishers can create pages at any position, and move existing pages
to any other position. Some exceptions to this can apply based on a page's
configuration (see below).

### Page configuration

A page's configuration is applied via it's _type_. This connects the page to a
particular ruby class (like Rails' STI mechanism). The page class provides the
configuration in a `.config` class method:

```ruby
class ContentPage < Heracles::Page
  def self.config
    {
      fields: [
        {name: "primary_content", type: "content", required: "true"}
        {name: "secondary_content", type: "content"}
      ]
    }
  end
end
```

`.config` returns a simple hash containing the site configuration. This allows
site developers the greatest flexibility in configuring pages: they can subclass
existing page classes and modify the config in arbitrary ways.

The page config has the following keys:

**fields**

An array of the page's fields. These will be shown when the page is edited in
the admin area. Each field is a hash that can contain the following values:

* `name` (required): the field's name.
* `type` (required): the field's type.
* `required` (optional): true if the field must be filled in for the page to be
  valid.
* `hint` (optional): a string of helpful text that shows alongside the field in
  the admin area.

**allowed_children**

_Not yet implemented._

An array of page types that publishers can add as the page's children within the
tree, e.g.

```ruby
{
  allowed_children: [:info_page, :staff_profile_page]
}
```

Each value within `allowed_children` is an underscored-formatted name for a page
type. In the admin area, only these page types will be allowed as children. If
`allowed_children` is not specified, then any page type will be allowed.

**default_children**

An array of child pages that are built automatically along with the page, e.g.

```ruby
{
  default_children: [
    {name: "Degree Requirements", slug: "degree-requirements", type: :info_page},
    {name: "Contact", slug: "contact", type: :contact_page}
  ]
}
```

Each page in the `default_children` array requires a `slug` and `type`.

When the parent page is created, these child pages will be created
automatically. They will initially be unpublished, and can also later be
removed.

### Page rendering

When a public request is made for a page, the template file for rendering is
looked up according to these rules:

1. Using the page record's `template` attribute, if it's present. The template
   is looked up in a path scoped by the page's type. For example, a request for
   a page with the type "content_page" and a template of "special" looks for a
   template at `pages/content_page/special.html.slim`.
2. Using a template with the same name as the page's type (e.g.
   `pages/content_page.html.slim`).
3. Finally, falling back to a standard `pages/show.html.slim`, if it exists.

Since each site is an engine, all templates are loaded from
`app/views/heracles/sites/<site_slug>/pages` within the `sites/<site_slug>`
engine directory.

## Fields

Each page has many fields, for containing its content. The fields available for
each page are determined by the `fields` key in the page's config hash. These
fields are automatically made available in the admin area when editing the page.

There are different types of fields. Right now, there are two basic types:

* Text: plain single-line strings
* Content: longer, multi-line text blocks. Edited using a WYSIWYG editor.
  Content fields also have _insertables._ These are just specially encoded data
  chunks within the larger string that can be output in different ways (e.g.
  images & links).
* Booleans
* Integers
* Floats
* Date & time
* Arrays
* Associated pages: links to other pages within the site.
* Assets: links to uploaded assets.

Fields are rich blocks of content. They have their own classes (the core field
classes are in `engines/heracles_core/lib/heracles/fielded`). Fields are
composed of one or more attributes. _Simple_ fields (like text and content
fields) will just have a single `value` attribute, but _compound_ fields may
contain multiple attributes (e.g. a location field would have at least
`latitude`, `longitude` and `address` attributes).

### Dynamic fields

Apart from the fields specified in the site configuration, a page's backing Ruby
class may also provide additional fields dynamically. This allows for some extra
smarts to be involved in the fields that a page provides. For example,
additional fields could be provided based on the state of a page's parent, or on
its position in the page tree.

This can be achieved by implementing the `#fields_config` _instance_ method on
the class:

```ruby
class ContentPage < Heracles::Page
  def self.config
    {
      fields: [
        {name: "body", label: "Main content", type: :content}
      ]
    }
  end

  def fields_config
    super + [{name: "extra_field", type: :content}]
  end
end
```

### Field persistence

When a page is saved, all of its field content is serialized into JSON and saved
into a single JSON column in the database. This is what allows the system to
store varying content across pages while still keeping everything in a single
database table.

## Advanced site engine techniques

### Site inheritance

The University of Melbourne will host many similar sites in one application
instance. They want to reuse page behaviour, page templates & i18n values across
these sites wherever possible.

While each site is a separate, isolated Rails engine, because they are
co-located within the same app, they can depend on _other_ site engines for code
reuse, so a single abstract non-serveable engine (e.g.
`Heracles::Sites::AbstractUnimelbCourseSite`) could be used to provide common
behaviour. Each individual site engine could opt-in to use various parts of this
abtract engine.

#### Page type inheritance

While each site must provide their own concrete set of page classes, these do
not necessarily need to inherit directly from `Heracles::Page`. Instead, they
could be thin wrappers around other page subclasses defining common behaviour:

```ruby
module Heracles
  module Sites
    module AbstractUnimelbCourseSite
      class ContentPage < Heracles::Page
        def self.config
          # Common config here
        end
      end
    end
  end
end

module Heracles
  module Sites
    module ConcreteCourseSite
      class ContentPage < Heracles::Sites::AbstractUnimelbCourseSite::ContentPage
        # Common config is inherited
      end
    end
  end
end
```

#### Field & insertables inheritance

Unlike pages, the classes for fields and insertables don't need to have concrete
implementations directly within the site's own namespace. This means that a site
can use standard module mixins to use a common set of fields and insertables.

For example, if the abstract engine provides its own insertable renderer:

```ruby
module Heracles
  module Sites
    module AbstractUnimelbCourseSite
      class ImageInsertableRenderer
        # ...
      end
    end
  end
end
```

Then a concrete site engine can make this renderer available (along with any
other renderer classes and field classes) by mixing in the abstract site's
module:

```ruby
module Heracles
  module Sites
    module ConcreteCourseSite
      include Heracles::Sites::AbstractUnimelbCourseSite
    end
  end
end
```

If the concrete site engine wanted to override particular classes otherwise
provided by the abstract engine, it could simply have its own direct
implementations of these classes.

Since fields and insertables also require support for the admin interface, the
concrete site engine would also need to include any supporting JavaScript and
CSS assets, e.g. in
`sites/concrete_course_site/app/assets/javascripts/heracles/sites/concrete_course_site/admin.js`:

```javascript
//= require heracles/sites/abstract_unimelb_course_site/admin
```

And in `sites/concrete_course_site/app/assets/stylesheets/heracles/sites/concrete_course_site/admin.css.scss`:

```scss
// Fields

@import "heracles/sites/abstract_unimelb_course_site/admin/fields/some_field_type";
@import "heracles/sites/abstract_unimelb_course_site/admin/fields/another_field_type";
```

#### Page template & layout inheritance

This can be achieved using [nestive](https://github.com/rwz/nestive) and direct
template file rendering.

e.g. for site layouts, in `sites/abstract_unimelb_course_site/app/views/layouts/heracles/sites/abstract_unimelb_course_site/application.html.slim`:

```slim
doctype html
html
  head
    title
      = area :page_title do
        = page.title if respond_to?(:page)
  body
    .some-common-layout-here
      area :body
```

And in `sites/concrete_course_site/app/views/layouts/heracles/sites/concrete_course_site/application.html.sim`:

```slim
/ Inherit directly from common layout
= extends "layouts/heracles/sites/abstract_unimelb_course_site/application" do
  = yield
```

And for page templates, e.g. in `sites/abstract_unimelb_course_site/app/views/heracles/sites/abstract_unimelb_course_site/pages/content_page.html.slim`

```slim
= replace :main do
  .some-content-page-specific-stuff
    | Goes here
```

And in `sites/abstract_unimelb_course_site/app/views/heracles/sites/concrete_course_site/pages/content_page.html.slim`

```slim
/ Example of extending the main block with custom content:
/ = prepend :main do
/   ' I will be prepended

/ Inherit from abstract_unimelb_course_site. Load order for this is odd, so the
/ render call need to come after the defined areas
= render "heracles/sites/abstract_unimelb_course_site/2013/pages/content_page"
```

#### i18n inheritance

Inheritance for i18n values from a common engine is very simple to set up.
Create an `en.yml` file in the abstract common engine:

```yml
en:
  unimelb_course_site:
    name_for_degree: course
```

And another in the concrete site engine:

```yml
# Provide site-specific overrides for unimelb_gradiate_common's en.yml here.
en:
  unimelb_course_site: {}
```

This arrangement allows for the `unimelb_course_site.name_for_degree` i18n value
to be used both within the abstract site and concrete site's templates. The
concrete site can optionally add or override i18n values within its own `en.yml`
file.

## Tags

Assets and Pages are taggable entities using [Acts as Taggable On](https://github.com/mbleigh/acts-as-taggable-on). By default tags are delimited by a comma `,`, but this can be changed by setting the Acts as Taggable On delimiter in an initializer should you require commas in your tags:

```ruby
ActsAsTaggableOn.delimiter = ";"
```

Note, this setting will apply _across every site_ in your application.

## Cutting a new version/release
Make sure you have a gemfury remote setup for the repo. If not add it:

```sh
git remote add fury https://<gemfury-username>@git.fury.io/icelab/heracles.git
```

Edit the `lib/heracles/version.rb` to the new version number. Commit the change.

Then run (replacing the version number):

```sh
git tag v2.0.0.beta67
git push
git push origin v2.0.0.beta67
git push fury
```
