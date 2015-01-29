# RspecTruthTable

Provides a DSL to define a set of tests based on a truth table - for RSpec

## Installation

Add this line to your application's Gemfile:

    gem 'rspec_truth_table'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_truth_table

## Usage

Include the truth_table helpers in RSpec Config

    RSpec.configure do |config|
      config.extend RspecTruthTable::Helpers
    end

Define a subject

    describe "boolean_method" do
      subject { boolean_method(x, y, z) }

    end

use the `truth_table` helper in your describe / context block.

    describe "boolean_method" do
      subject { boolean_method(x, y, z) }

      truth_table do

      end
    end

Inside the `truth_table` block, use the `setup` method to define a block that sets up the state of the test. Any arguments you specify to `setup` will be available to any `let` or `before` methods used inside it, these will be either `true` or `false` when the test is run. You can then use them to optionally factory an object or do other initialization steps.

    describe "boolean_method" do
      subject { boolean_method(x, y, z) }

      truth_table do
        setup do |x, y, z|
           let(:x) { x }
           let(:y) { y }
           let(:z) { z }
        end
      end
    end

Outside of the setup block, define a truth table with inputs and outputs. This table will have one column more than the number of inputs, as the final column specifies the expected result of the subject.

    describe "boolean_method" do
      subject { boolean_method(x, y, z) }

      truth_table do
        setup do |x, y, z|
           let(:x) { x }
           let(:y) { y }
           let(:z) { z }
        end

      # X | Y | Z | R
      # -------------
        t | t | t | f
        t | t | f | f
        t | f | t | t
        t | f | f | f
        f | t | t | t
        f | t | f | f
        f | f | t | f
        f | f | f | f
      end

    end

You can also use `x` as a wild card input, this will define tests for `true` and `false` and can aid in defining intent greatly. The following example performs the same test as above.

    describe "boolean_method" do
      subject { boolean_method(x, y, z) }

      truth_table do
        setup do |x, y, z|
           let(:x) { x }
           let(:y) { y }
           let(:z) { z }
        end

        # X | Y | Z | R
        # -------------
          x | x | f | f # always false if Z is false
          t | t | x | f # X ^ Y
          f | f | x | f # X ^ Y

          x | x | x | t # The rest should result in true
      end
    end


## Contributing

1. Fork it ( http://github.com/thefrontiergroup/rspec_truth_table/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
