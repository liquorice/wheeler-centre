#Heracles setup from scratch

##Create a basic Rails site

The Icelab reccomended approach is to use our Rails skeleton:
```
https://github.com/icelab/rails-skeleton
```

Enter the following commands:
```
gem install raygun
raygun -p icelab/rails-skeleton <name-of-project>
bundle update
bundle install
bin/setup
rake db:migrate
```

Check that you can run the application
```
foreman start
```

##Install Heracles

Add the privately hosted gem to your Gemfile as described in the main Readme.
```
gem "heracles", git: "git@bitbucket.org:icelab/heracles.git", branch: "master"
```

Then `bundle install` and `rake db:migrate`

##Start development!

You can then start adding authentication and User Models as described in the main Readme eg: `gem install devise`.

###Other notes

If you want to use a .env file, you'll need to install the `dotenv` gem in the development gems.
If you want or need to remove the Github source of the `react-rails` gem - it's available on Ruby Gems.
