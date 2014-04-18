require 'tempfile'
module RSpec
  module ExampleTest

    def create_truth_table_test(expression, setup, table)
      file = Tempfile.new("truth_table_spec.rb")

      file.write <<RUBY
require 'rspec'
require 'rspec_truth_table'

RSpec.configure do |config|
  config.extend RspecTruthTable::Helpers
end

describe 'xor' do
  subject(:xor) { #{expression} }

  truth_table do
    #{setup}

    #{table}
  end
end
RUBY
      file.close(false)
      file
    end

  end
end
