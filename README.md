# TraceGraph

TraceGraph gives you visibility into the control flow of your application. Rather than read all the code
trying to form a mental picture of it, let TraceGraph draw you a picture like this:

![Document Worker Trace](docs/images/document_worker_trace.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trace_graph'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trace_graph

## Usage

A simple use might look like this:

```ruby
foo = Foo.new
tracer = TraceGraph::Tracer.new({ included_paths: ["foo"], png: 'foo_trace.png' })
tracer.trace{ foo.foo_both }
```

You'd see output like this in your console:

```
trace
└─Foo#foo_both
  ├─Foo#first_method
  └─Foo#second_method
```

And a graph like this would be generated at `foo_trace.png`


![Document Worker Trace](docs/images/foo_trace.png)




## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/trace_graph. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TraceGraph project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/trace_graph/blob/master/CODE_OF_CONDUCT.md).
