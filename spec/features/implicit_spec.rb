require 'spec_helper'

describe 'A implicit table' do
  subject do
    @file = create_truth_table_test(expression, setup, table)
    `rspec #{@file.path} 2>&1`
  end

  after(:each) do
    @file.unlink
  end

  let(:expression) { "x ^ y" }
  let(:setup) { <<-RUBY }
    setup do |x, y|
      let(:x) { x }
      let(:y) { y }
    end
  RUBY

  context "when the table matches the expression" do
    let(:table) { <<-RUBY }
      t | f | t
      f | t | t

      x | x | f
    RUBY

    it { should include "4 examples, 0 failures" }
  end

  context "when the table has one definition which does not match the expression" do
    let(:table) { <<-RUBY }
      t | f | t
      f | t | t
      t | t | t

      x | x | f
    RUBY

    it { should include "4 examples, 1 failure" }
  end

  context "with multiple columns" do
    let(:expression) { "x ^ y && z" }
    let(:setup) { <<-RUBY }
      setup do |x, y, z|
        let(:x) { x }
        let(:y) { y }
        let(:z) { z }
      end
    RUBY

    let(:table) { <<-RUBY }
      x | x | f | f # always false if z is false
      t | t | x | f # X ^ Y
      f | f | x | f # X ^ Y

      x | x | x | t # The rest are true
    RUBY

    it { should include "8 examples, 0 failures" }
  end
end
