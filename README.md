# Knapsack

[![Gem Version](https://badge.fury.io/rb/knapsack.png)][gem_version]
[![Build Status](https://travis-ci.org/ArturT/knapsack.svg?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/ArturT/knapsack.png)][codeclimate]
[![Coverage Status](https://codeclimate.com/github/ArturT/knapsack/coverage.png)][coverage]

[gem_version]: https://rubygems.org/gems/knapsack
[travis]: http://travis-ci.org/ArturT/knapsack
[codeclimate]: https://codeclimate.com/github/ArturT/knapsack
[coverage]: https://codeclimate.com/github/ArturT/knapsack

Parallel specs across CI server nodes based on each spec file's time execution.

**Work in progress, gem is not ready yet!**

## Installation

Add this line to your application's Gemfile:

    gem 'knapsack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install knapsack

## Usage

Add at the beginning of your `spec_helper.rb`:

    require 'knapsack'

    # default configuration, you can change it or omit completely
    Knapsack.tracker.config({
        enable_time_offset_warning: true,
        time_offset_in_seconds: 30
    })

    # default configuration for report, you can change it or omit completely
    Knapsack.report.config({
      report_path: 'knapsack_report.json'
    })

    Knapsack::Adapters::RspecAdapter.bind

Generate time execution report for your spec files.

    $ KNAPSACK_GENERATE_REPORT=true rspec spec

Commit generated report `knapsack_report.json` into your repository.

## Setup your CI server

On your CI server run this command for the first CI node. Update `CI_NODE_INDEX` for the next one.

    $ CI_NODE_TOTAL=2 CI_NODE_INDEX=0 KNAPSACK_SPEC_PATTERN="directory_with_specs/**/*_spec.rb" bundle exec rake knapsack:rspec

You can omit `KNAPSACK_SPEC_PATTERN` if your specs are in `spec` directory.

`CI_NODE_TOTAL` - total number CI nodes you have.

`CI_NODE_INDEX` - index of current CI node starts from 0. Second CI node should have `CI_NODE_INDEX=1`.

### Info for CircleCI users

If you are using circleci.com you can omit `CI_NODE_TOTAL` and `CI_NODE_INDEX`. Knapsack will use `CIRCLE_NODE_TOTAL` and `CIRCLE_NODE_INDEX` provided by CircleCI.

Here is example for test configuration in your `circleci.yml` file.

    test:
      override:
        - bundle exec rake knapsack:rspec
            parallel: true

## Tests

### Spec

To run specs for Knapsack gem type:

    $ rspec spec

### Spec examples

Directory `spec_examples` contains examples of fast and slow specs. There is a `spec_example/spec_helper.rb` with binded Knapsack.

To generate a new knapsack report for specs with `focus` tag (only specs in `spec_examples/leftover` directory have no `focus` tag), please type:

    $ KNAPSACK_GENERATE_REPORT=true rspec --default-path spec_examples --tag focus

**Warning:** Current `knapsack_report.json` file was generated for `spec_examples` except `spec_examples/leftover` directory. Just for testing reason to see how leftover specs will be distribute in a dumb way across CI nodes.

To see specs distributed for the first CI node type:

    $ CI_NODE_TOTAL=2 CI_NODE_INDEX=0 KNAPSACK_SPEC_PATTERN="spec_examples/**/*_spec.rb" bundle exec rake knapsack:rspec

Specs in `spec_examples/leftover` take more than 3 seconds. This should cause a Knapsack time offset warning because we set `time_offset_in_seconds` to 3 in `spec_examples/spec_helper.rb`. Type below to see warning:

    $ rspec --default-path spec_examples

## Contributing

1. Fork it ( https://github.com/[my-github-username]/knapsack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
