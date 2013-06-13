= Cadenero
By [AgilTec](http://agiltec.com.mx/).

[![Gem Version](https://fury-badge.herokuapp.com/rb/cadenero.png)](http://badge.fury.io/rb/cadenero)
[![Build Status](https://api.travis-ci.org/plataformatec/devise.png?branch=master)](http://travis-ci.org/plataformatec/devise)
[![Code Climate](https://codeclimate.com/github/plataformatec/devise.png)](https://codeclimate.com/github/plataformatec/devise)

Authentication Engine for Rails.API multitenant RESTful APIs based on Warden. It:
* Is Racked based
* Use token authentication as strategy for the API
* Is RESTful API
* Allows you to have multiple roles (or models/scopes) signed in at the same time

## Information

### Why Cadenero?
**"Cadenero"** is the spanish word for ["Bouncer (doorman)":http://en.wikipedia.org/wiki/Bouncer_(doorman)]. The main function of **Cadenero** is to be a resource for authenticating consumers of the services that the API provides. As the real bouncers, **Cadenero** aims to provide security, check authorized access, to refuse entry for intoxication, aggressive behavior or non-compliance with statutory or establishment rules. 

### The Cadenero wiki

### Bug reports

If you discover a problem with **Cadenero**, we would like to know about it. However, we ask that you please review these guidelines before submitting a bug report:

https://github.com/agiltec/cadenero/wiki/Bug-reports

If you found a security bug, do *NOT* use the GitHub issue tracker. Send an email to the maintainers listed at the bottom of the README please.

### Contributing

We hope that you will consider contributing to **Cadenero**. Please read this short overview for some information about how to get started:

https://github.com/agiltec/devise/cadenero/Contributing

You will usually want to write tests for your changes using BDD tools as RSpec, Rack::Test and Capybara.  To run the test suite, go into **Cadenero**'s top-level directory and run "bundle install" and "rspec".  For the tests to pass, you will need to have a Postgresql server running on your system.

### Warden

**Cadenero** is based on Warden, which is a general Rack authentication framework created by Daniel Neighman. We encourage you to read more about Warden here:

https://github.com/hassox/warden

### Rails::API

**Cadenero** is a Rails::API Engine, Rails::API is a subset of a normal Rails application, created for applications that don't require all functionality that a complete Rails application provides. It is a bit more lightweight, and consequently a bit faster than a normal Rails application. The main example for its usage is in API applications only, where you usually don't need the entire Rails middleware stack nor template generation. Rails::API was created by Santiago Pastorino. We encourage you to read more about Warden here:

https://github.com/rails-api/rails-api


### Maintainers

* Manuel Vidaurre (https://github.com/mvidaurre)

## License

MIT License. Copyright 2013 AgilTec. http://agiltec.com.mx

You are not granted rights or licenses to the trademarks of the AgilTec, including without limitation the **Cadenero** name or logo.


This project rocks and uses MIT-LICENSE.