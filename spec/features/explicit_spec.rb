require 'spec_helper'

describe 'A explicit table' do
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
      t | t | f
      t | f | t
      f | t | t
      f | f | f
    RUBY

    it { should include "4 examples, 0 failures" }
  end

  context "when the table has one definition which does not match the expression" do
    let(:table) { <<-RUBY }
      t | t | f
      t | f | t
      f | t | t
      f | f | t
    RUBY


    it { should include "4 examples, 1 failure" }
  end

  context "when the table has no definitions match the expression" do
    let(:table) { <<-RUBY }
      t | t | t
      t | f | f
      f | t | f
      f | f | t
    RUBY


    it { should include "4 examples, 4 failures" }
  end

  context "when the table is missing a definition" do
    let(:table) { <<-RUBY }
      t | t | t
      t | f | f
      f | t | f
    RUBY

    it { should include "Row undefined" }
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
      t | t | t | f
      t | t | f | f
      t | f | t | t
      t | f | f | f
      f | t | t | t
      f | t | f | f
      f | f | t | f
      f | f | f | f
    RUBY

    it { should include "8 examples, 0 failures" }
  end
end
