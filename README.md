![Cadenero Logo](https://raw.github.com/AgilTec/cadenero/master/cadenero.logo.png)
By [![Agiltec Logo](https://launchrock-assets.s3.amazonaws.com/logo-files/GpujzvLXPPqzAcz.png)](http://agiltec.github.io/).

[![Gem Version](https://fury-badge.herokuapp.com/rb/cadenero.png)](http://badge.fury.io/rb/cadenero)
[![Build Status](https://travis-ci.org/AgilTec/cadenero.png?branch=master)](https://travis-ci.org/AgilTec/cadenero)
[![Code Climate](https://codeclimate.com/github/AgilTec/cadenero.png)](https://codeclimate.com/github/AgilTec/cadenero)
[![Coverage Status](https://coveralls.io/repos/AgilTec/cadenero/badge.png?branch=master)](https://coveralls.io/r/AgilTec/cadenero?branch=master)
[![Dependency Status](https://gemnasium.com/AgilTec/cadenero.png)](https://gemnasium.com/AgilTec/cadenero)

THIS README IS FOR THE MASTER BRANCH OF **CADENERO** AND REFLECTS THE WORK CURRENTLY EXISTING ON THE MASTER BRANCH. IF YOU ARE WISHING TO USE A NON-MASTER BRANCH OF **CADENERO**, PLEASE CONSULT THAT BRANCH'S README AND NOT THIS ONE.

Authentication Engine for Rails.API multitenant RESTful APIs based on Warden. It:
* Is Racked based
* Use token authentication as strategy for the API
* Is RESTful API
* Allows you to have multiple roles (or models/scopes) signed in at the same time

## Information

### Why Cadenero?
**"Cadenero"** is the spanish word for ["Bouncer (doorman)"](http://en.wikipedia.org/wiki/Bouncer_(doorman\)). The main function of **Cadenero** is to be a resource for authenticating consumers of the services that the API provides. As the real bouncers, **Cadenero** aims to provide security, check authorized access, to refuse entry for intoxication, aggressive behavior or non-compliance with statutory or establishment rules.

You can use [Warden](https://github.com/hassox/warden) or [Devise](https://github.com/plataformatec/devise) directly but for API apps the rewritting and monkey patching can be messy.

### Installing **Cadenero**

#### Preconditions

##### Postgresql
You should have a Postgresql server (for downloading see: http://www.postgresql.org/download/). If you are using OSX, you can install using [Homebrew](http://mxcl.github.io/homebrew/) for that you can follow the following this [instructions](http://www.moncefbelyamani.com/how-to-install-postgresql-on-a-mac-with-homebrew-and-lunchy/)

##### Ruby 1.9.x or 2.x
For that we recommend that you use [rbenv](https://github.com/sstephenson/rbenv) with [ruby-build](https://github.com/sstephenson/ruby-build) or [rvm](https://rvm.io/)

We use the standard `rake`, `bundler` and `gem`

##### Git/Github
You are here. Then you know what to do ;-)

#### Setup

Rails 3.2.13 is the master version used now by **Cadenero**, if you want to use Rails 4 goodness please use the branch "rails4"

Generate first your Rails app as usual using:

```
    $ rails _3.2.13_ new your_app --skip-test-unit  -d postgresql
```

In the `Gemfile` add the following lines:
```ruby
    gem 'cadenero', '~> 0.0.2.b10'

    group :development, :test do
      gem 'rspec-rails', '~> 2.14.0'
      gem 'capybara', '~> 2.1.0'
      gem 'rack-test', '~> 0.6.2'
    end
```

In the `config/database.yml` replace the `sqlite3` adapter for `postgresql` as follow:

```
    development:
      adapter: postgresql
      encoding: unicode
      database: your_app_development 
      pool: 5
      min_messages: warning

    test:
      adapter: postgresql
      encoding: unicode
      database: your_app_test
      pool: 5
      min_messages: warning
```

Then run bundle, create the databases and run the generator:

```
    $ bundle install; rake db:create; rails-api g cadenero:install
```

Finally run the server:

```
    $ rails-api s
```

Or much better for checking the multitenancy you can use [Pow](http://pow.cx/). To install or upgrade Pow, open a terminal and run this command:

```
    $ curl get.pow.cx | sh (View Source)
```

To set up a Rack app, just symlink it into ~/.pow:

```
    $ cd ~/.pow
    $ ln -s /path/to/myapp
```

Check that you can access the API using the default account `www` and user `testy@example.com` with password `changeme˜ or those defined for you when the generator was run. Ror the client you can use [cURL](http://curl.haxx.se/) or [RESTClient](http://restclient.net/)

You can create a new account as follows:

```
    $ curl -v -X POST http://www.cadenero.dev/v1/accounts -H 'Content-Type: application/json' -d '{"account": { "name": "Testy", "subdomain": "tested1", "owner_attributes": {"email": "testy2@example.com", "password": "changeme", "password_confirmation": "changeme"}}}'
```
Or

```
    Request

    POST http://www.cadenero.dev/v1/accounts

        Content-Type: application/json

    Body
    {"account": { "name": "Testy", "subdomain": "test2", "owner_attributes": {"email": "testy2@example.com", "password": "changeme", "password_confirmation": "changeme"}}}
```

Have fun!

### Access Points
**Cadenero** creates the following versioned routes for exposing the authentication RESTful API

```
            v1_root        /v1(.:format)           cadenero/v1/account/dashboard#index {:default=>:json}
        v1_sessions POST   /v1/sessions(.:format)  cadenero/v1/account/sessions#create {:default=>:json}
                    DELETE /v1/sessions(.:format)  cadenero/v1/account/sessions#delete {:default=>:json}
           v1_users POST   /v1/users(.:format)     cadenero/v1/account/users#create {:default=>:json}
                 v1 GET    /v1/users/:id(.:format) cadenero/v1/account/users#show {:default=>:json}
        v1_accounts POST   /v1/accounts(.:format)  cadenero/v1/accounts#create {:default=>:json}
               root        /                       cadenero/v1/account/dashboard#index {:default=>:json}
```

You can check them running:

```
    $ rake routes
```
### Strategies
For authentication **Cadenero** has two default Warden Strategies:
  * **Password**. That expect that the client to keep a session cookie and using for authentication the user `email` and `password`.
  * **Token Authentication**. That is stateless and expects that for each request the user include the `auth_token` as a key-value of the request params.

In any case when you signed up **Cadenero** creates an auth_token for the membership to the account that you signed up.

If you want to know more about Warden Strategies see: https://github.com/hassox/warden/wiki/Strategies

### Documentation
You can review the YARD docs in: http://rubydoc.info/github/AgilTec/cadenero/frames

### The Cadenero Task List
- [x] Specs for the code 100% Coverage using BDD with [Rspec](https://github.com/rspec/rspec) and [Capybara](https://github.com/jnicklas/capybara)
- [x] Documentation for all the code
- [ ] Examples of use and demo

### Versions
**Cadenero** aims to adhere to [Semantic Versioning 2.0.0](http://semver.org/) the current version is: 0.0.2-b10 meaning MAJOR.MINOR.PATCH format. Violations of this scheme should be reported as bugs. Specifically, if a minor or patch version is released that breaks backward compatibility, that version should be immediately yanked and/or a new version should be immediately released that restores compatibility. Breaking changes to the public API will only be introduced with new major versions. As a result of this policy, you can (and should) specify a dependency on this gem using the [Pessimistic Version Constraint](http://docs.rubygems.org/read/chapter/16#page74) with two digits of precision. For example:

```
    spec.add_dependency 'cadenero', '~> 1.0'
```

### Bug reports

If you discover a problem with **Cadenero**, we would like to know about it. However, we ask that you please review these guidelines before submitting a bug report:

https://github.com/AgilTec/cadenero/wiki/Bug-reports

To submit the bug or issue go to: https://github.com/AgilTec/cadenero/issues

If you found a security bug, do *NOT* use the GitHub issue tracker. Send an email to the maintainers listed at the bottom of the README please.

### Contributing

We hope that you will consider contributing to **Cadenero**. You're encouraged to submit pull requests, propose features and discuss issues.

  * Fork the project
  * Write test for your new feature or a test that reproduces a bug
  * Implement your feature or make a bug fix
  * Commit, push and make a pull request. Bonus points for topic branches.

You will usually want to write tests for your changes using BDD tools as RSpec, Rack::Test and Capybara.

To run the test suite, go into **Cadenero**'s top-level directory and run `bundle install` and `rspec spec`.  For the tests to pass, you will need to have a Postgresql server running on your system.

If you have not contribute before in a Github repo please review first:

  * [Fork A Repo](https://help.github.com/articles/fork-a-repo)
  * [Using Pull Requests](https://help.github.com/articles/using-pull-requests)

#### Running the Specs
**Cadenero** use [RSpec](https://github.com/rspec/rspec) and [Capybara](https://github.com/jnicklas/capybara). To run the specs you only need to do:

```
    $ RAILS_ENV=test bundle exec rake db:create
    $ RAILS_ENV=test bundle exec rake db:migrate
    $ bundle exec rspec spec
```

You can `binstub` the command bins to avoid writing `bundle exec`. You only need to write:
```
    $ bundle binstubs rspec-core
    $ bundle binstubs rake
```

### Warden

**Cadenero** is based on [Warden](https://github.com/hassox/warden), which is a general Rack authentication framework created by Daniel Neighman. We encourage you to read more about Warden here: https://github.com/hassox/warden/wiki

#### Devise
Some code and architectural decisions in **Cadenero** have been inspired for the excellent gem [Devise](https://github.com/plataformatec/devise).

### Rails::API

**Cadenero** is a Rails::API Engine, Rails::API is a subset of a normal Rails application, created for applications that don't require all functionality that a complete Rails application provides. It is a bit more lightweight, and consequently a bit faster than a normal Rails application. The main example for its usage is in API applications only, where you usually don't need the entire Rails middleware stack nor template generation. Rails::API was created by Santiago Pastorino. We encourage you to read more about Rails::API here: https://github.com/rails-api/rails-api

### Multitenancy with Rails And subscriptions too!
Parts of the code of **Cadenero** have been based on the excellent work of [Ryan Bigg](https://github.com/radar) in his book ["Multitenancy with Rails And subscriptions too!"](https://leanpub.com/multi-tenancy-rails) but modified to be use in a RESTful API

### Maintainers

* [Manuel Vidaurre](https://github.com/mvidaurre)

## License

MIT License. Copyright 2013 AgilTec. http://agiltec.com.mx

You are not granted rights or licenses to the trademarks of the AgilTec, including without limitation the **Cadenero** name or logo.


This project rocks and uses MIT-LICENSE.