![Cadenero Logo](https://raw.github.com/AgilTec/cadenero/master/cadenero.logo.png)
By [![Agiltec Logo](https://launchrock-assets.s3.amazonaws.com/logo-files/GpujzvLXPPqzAcz.png)](http://agiltec.github.io/).

[![Gem Version](https://fury-badge.herokuapp.com/rb/cadenero.png)](http://badge.fury.io/rb/cadenero)
[![Build Status](https://travis-ci.org/AgilTec/cadenero.png?branch=master)](https://travis-ci.org/AgilTec/cadenero)
[![Code Climate](https://codeclimate.com/github/AgilTec/cadenero.png)](https://codeclimate.com/github/AgilTec/cadenero)
[![Coverage Status](https://coveralls.io/repos/AgilTec/cadenero/badge.png?branch=master)](https://coveralls.io/r/AgilTec/cadenero?branch=master)
[![Dependency Status](https://gemnasium.com/AgilTec/cadenero.png)](https://gemnasium.com/AgilTec/cadenero)

Authentication Engine for Rails.API multitenant RESTful APIs based on Warden. It:
* Is Racked based
* Use token authentication as strategy for the API
* Is RESTful API
* Allows you to have multiple roles (or models/scopes) signed in at the same time

## Information

### Why Cadenero?
**"Cadenero"** is the spanish word for ["Bouncer (doorman)"](http://en.wikipedia.org/wiki/Bouncer_(doorman\)). The main function of **Cadenero** is to be a resource for authenticating consumers of the services that the API provides. As the real bouncers, **Cadenero** aims to provide security, check authorized access, to refuse entry for intoxication, aggressive behavior or non-compliance with statutory or establishment rules. 

### Installing **Cadenero**
Generate first your Rails.API app as usual using:

```
    $ rails-api new your_app --skip-test-unit
```

In the `Gemfile` add the following lines:
```ruby
    gem 'cadenero', '~> 0.0.2.b2'
    gem 'pg'
```

In the `config/database.yml` replace the `sqlite3` adapter for `postgresql` as follow:

```
    development:
      adapter: postgresql
      database: your_app_development 
      min_messages: warning

    test:
      adapter: postgresql
      database: your_app_test 
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
        v1_root        /v1(.:format)          cadenero/v1/account/dashboard#index {:default=>:json}
    v1_sessions POST   /v1/sessions(.:format) cadenero/v1/account/sessions#create {:default=>:json}
                DELETE /v1/sessions(.:format) cadenero/v1/account/sessions#delete {:default=>:json}
       v1_users POST   /v1/users(.:format)    cadenero/v1/account/users#create {:default=>:json}
    v1_accounts POST   /v1/accounts(.:format) cadenero/v1/accounts#create {:default=>:json}
           root        /                      cadenero/v1/account/dashboard#index {:default=>:json}
```

You can check them running:

```
    rake routes
```
### Documentation
You can review the YARD docs in: http://rubydoc.info/github/AgilTec/cadenero/frames

### The Cadenero Task List
- [x] Specs for the code 100% Coverage using BDD with [Rspec](https://github.com/rspec/rspec) and [Capybara](https://github.com/jnicklas/capybara)
- [x] Documentation for all the code
- [ ] Examples of use and demo

### Versions
**Cadenero** use [Semantic Versioning 2.0.0](http://semver.org/) the current version is: 0.0.2-alpha meaning MAJOR.MINOR.PATCH format

### Bug reports

If you discover a problem with **Cadenero**, we would like to know about it. However, we ask that you please review these guidelines before submitting a bug report:

https://github.com/AgilTec/cadenero/wiki/Bug-reports

If you found a security bug, do *NOT* use the GitHub issue tracker. Send an email to the maintainers listed at the bottom of the README please.

### Contributing

We hope that you will consider contributing to **Cadenero**. Please read this short overview for some information about how to get started:

https://github.com/AgilTec/cadenero/Contributing

You will usually want to write tests for your changes using BDD tools as RSpec, Rack::Test and Capybara.  To run the test suite, go into **Cadenero**'s top-level directory and run "bundle install" and "rspec".  For the tests to pass, you will need to have a Postgresql server running on your system.

### Warden

**Cadenero** is based on Warden, which is a general Rack authentication framework created by Daniel Neighman. We encourage you to read more about Warden here: https://github.com/hassox/warden

### Rails::API

**Cadenero** is a Rails::API Engine, Rails::API is a subset of a normal Rails application, created for applications that don't require all functionality that a complete Rails application provides. It is a bit more lightweight, and consequently a bit faster than a normal Rails application. The main example for its usage is in API applications only, where you usually don't need the entire Rails middleware stack nor template generation. Rails::API was created by Santiago Pastorino. We encourage you to read more about Rails::API here: https://github.com/rails-api/rails-api

### Multitenancy with Rails And subscriptions too!
Parts of the code of **Cadenero** have been based on the excellent work of [Ryan Bigg](https://github.com/radar) in his book ["Multitenancy with Rails And subscriptions too!"](https://leanpub.com/multi-tenancy-rails) but modified to be use in a RESTful API

### Maintainers

* Manuel Vidaurre (https://github.com/mvidaurre)

## License

MIT License. Copyright 2013 AgilTec. http://agiltec.com.mx

You are not granted rights or licenses to the trademarks of the AgilTec, including without limitation the **Cadenero** name or logo.


This project rocks and uses MIT-LICENSE.