require_relative './truth_table'
module RspecTruthTable
  module Helpers
    def truth_table(&block)
      tt = TruthTable.new(self)

      tt.instance_exec(&block)

      tt._run
    end
  end
end
