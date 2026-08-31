# Net::Http::Tracer

This gem automatically traces all requests made with Net::HTTP.

## Supported Versions

- MRI Ruby 2.0 and newer

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nethttp-opentracing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nethttp-opentracing

## Usage

Set an OpenTracing-compatible tracer, such as ['jaeger-client'](https://github.com/signalfx/jaeger-client-ruby), as the global tracer.

Before making any requests, configure the tracer:

```ruby
require 'net/http/instrumentation'

Net::Http::Instrumentation.instrument
```

`instrument` takes optional parameters:
- `tracer`: the OpenTracing tracer to use to trace requests. Default: OpenTracing.global_tracer
- `ignore_request`: a bool or block to determine whether or not a given request
- `status_code_errors`: an array of `Net::HTTPResponse` classes that should have error tags added. Default: `[ ::Net::HTTPServerError ]`

`ignore_requests` should be configured to avoid tracing requests from the tracer
if it uses Net::HTTP to send spans. For example:

```ruby
# in the thread sending spans
Thread.current[:http_sender_thread] = true
...

# configure the instrumentation
Net::Http::Instrumentation.instrument(ignore_request: -> (host, req) { Thread.current[:http_sender_thread] })
```

To remove instrumentation:

```ruby
Net::Http::Instrumentation.remove
```

Spans are named `HTTP <METHOD> <host>` (e.g. `HTTP GET www.example.com`).

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Releasing

CI only validates builds; publishing the gem is a manual step. This gem is
published to Doximity's internal Nexus gem repository
(`https://artifacts.dox.support/repository/gems`), **not** to public
RubyGems.org. The gemspec's `allowed_push_host` enforces this — `rake release`
refuses to push anywhere but Nexus.

1. Bump the version in `lib/net/http/instrumentation/version.rb`.
2. Add a `CHANGELOG.md` entry for the new version.
3. Open a PR with those changes and merge it to `master`.
4. Tag the release and push the tag. The `v*` tag triggers the `final-release`
   CircleCI workflow, which runs the full build (specs, standardrb, docs)
   against the tag:

   ```
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

5. Wait for the tag build on CircleCI to pass.
6. Publish the gem:

   ```
   bundle exec rake release
   ```

   This builds `pkg/nethttp-opentracing-X.Y.Z.gem`, reuses the existing `vX.Y.Z`
   tag, and pushes the `.gem` file to Nexus.

Pushing requires Nexus credentials for the host in `~/.gem/credentials` (an
`:artifacts.dox.support` entry with your API token). `gem push` picks the
entry up automatically; if you prefer, the push can also be done manually:

```
gem push --host https://artifacts.dox.support/repository/gems pkg/nethttp-opentracing-X.Y.Z.gem
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/doximity/ruby-net-http-instrumentation.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://opensource.org/licenses/Apache-2.0).
