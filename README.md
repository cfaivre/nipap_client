# The Nipap Ruby Gem

[![Gem Version](https://badge.fury.io/rb/nipap_client.png)][gem]
[![Build Status](https://secure.travis-ci.org/cfaivre/nipap_client.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/cfaivre/nipap_client.png?travis)][gemnasium]
[![Code Climate](https://codeclimate.com/github/cfaivre/nipap_client.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/cfaivre/nipap_client/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/nipap_client
[travis]: http://travis-ci.org/cfaivre/nipap_client
[gemnasium]: https://gemnasium.com/cfaivre/nipap_client
[codeclimate]: https://codeclimate.com/github/cfaivre/nipap_client
[coveralls]: https://coveralls.io/r/cfaivre/nipap_client

A Ruby interface to Nipap (https://github.com/SpriteLink/NIPAP).

Uses the Twitter gem as a reference implementation: https://github.com/sferik/twitter

## Installation

    gem install nipap_client

## Quick Start Guide

Want to get up and start IPAMming?

```ruby
Nipap.configure do |config|
  config.username = YOUR_USERNAME
  config.password = YOUR_PASSWORD
end
```

That's it! You're ready to start managing IP addresses :
```ruby
Nipap.xxx("xxx")
```

For more examples of how to use the gem, read the [documentation][] or see [Usage Examples][] below.

[Usage Examples]: #usage-examples

## Documentation
[http://rdoc.info/gems/nipap_client][documentation]

[documentation]: http://rdoc.info/gems/nipap_client

## Configuration

Applications that make requests on behalf of a single Nipap user can pass
global configuration options as a block to the `Nipap.configure` method.

```ruby
Nipap.configure do |config|
  config.username = YOUR_USERNAME
  config.password = YOUR_PASSWORD
end
```

Alternately, you can set the following environment variables:

    HERMES_USERNAME
    HERMES_PASSWORD

After configuration, requests can be made like so:

```ruby
Nipap.mail("xxx", "xxx")
```

#### Nipap environments

By default Nipap Client points to http://nipap.avengers.hetzner.co.za

configuration variable. For example if you are hosting a local Nippa
You can change which Nipap service the client talks to with the :endpoint
server on your development machine;

```ruby
client = Nipap::Client.new(:endpoint => 'http://localhost:9393')
```

Alternatively;

```ruby
Nipap.configure do |config|
  config.endpoint = "http://your-staging-server.com"
end
```

(In a Rails application, this could go in `config/environments/staging.rb`.)


#### Thread Safety

Applications that make requests on behalf of multiple Nipap users should
avoid using global configuration. In this case, you may still specify the
`username` and `password` globally. (In a Rails application, this
could go in `config/initializers/nipap.rb`.)

```ruby
Nipap.configure do |config|
  config.username = YOUR_USERNAME
  config.password = YOUR_PASSWORD
end
```

Then, for each user's access token/secret pair, instantiate a
`Nipap::Client`:

```ruby
erik = Nipap::Client.new(
  :username => "Erik's username",
  :password => "Erik's secret"
)

john = Nipap::Client.new(
  :username => "John's username",
  :password => "John's secret"
)
```

You can now make threadsafe requests as the authenticated user:

```ruby
Thread.new { erik.mail("notify_unaudited_servers") }
Thread.new { john.mail("notify_unaudited_servers") }
```

Or, if you prefer, you can specify all configuration options when instantiating
a `Nipap::Client`:

```ruby
client = Nipap::Client.new(
  :username => "an application's consumer key",
  :password => "an application's consumer secret",
)
```

This may be useful if you're using multiple consumer key/secret pairs.

#### Middleware
The Faraday middleware stack is fully configurable and is exposed as a
`Faraday::Builder` object. You can modify the default middleware in-place:

```ruby
Nipap.middleware.insert_after Nipap::Response::RaiseError, CustomMiddleware
```

A custom adapter may be set as part of a custom middleware stack:

```ruby
Nipap.middleware = Faraday::Builder.new(
  &Proc.new do |builder|
    # Specify a middleware stack here
    builder.adapter :some_other_adapter
  end
)
```

## Usage Examples
All examples require an authenticated Hermes client. See the section on <a
href="#configuration">configuration</a> above.

**Mail (as the authenticated user)**

```ruby
Hermes.mail("notify_unaudited_servers")
Hermes.mail("notify_unaudited_servers")
```

## Performance
You can improve performance by loading a faster JSON parsing library. By
default, JSON will be parsed with [okjson][]. For faster JSON parsing, we
recommend [Oj][].

[okjson]: https://github.com/ddollar/okjson
[oj]: https://rubygems.org/gems/oj

## Supported Ruby Versions
This library aims to support and is [tested against][travis] the following Ruby
implementations:

* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0

If something doesn't work on one of these interpreters, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

## Versioning
This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, that version should be
immediately yanked and/or a new version should be immediately released that
restores compatibility. Breaking changes to the public API will only be
introduced with new major versions. As a result of this policy, you can (and
should) specify a dependency on this gem using the [Pessimistic Version
Constraint][pvc] with two digits of precision. For example:

    spec.add_dependency 'hermes', '~> 1.0'

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74

## Copyright
Copyright (c) 2013 Hetzner South Africa
See [LICENSE][] for details.

[license]: LICENSE.md
