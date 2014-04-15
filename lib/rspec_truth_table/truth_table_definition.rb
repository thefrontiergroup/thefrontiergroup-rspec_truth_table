module RspecTruthTable
    class TruthTableDefinition

      attr_reader :key

      def initialize(key, stack=[])
        self.key = key
        self.stack = stack
        self._columns = [self]
      end

      def columns
        _columns.dup
      end

      def |(following)
        _columns << following
        stack.pop
        self
      end

      def to_s
        key.to_s
      end

      def ==(other)
        self.key == :any || other.key == :any || self.key == other.key
      end

      private

      attr_accessor :_columns, :stack
      attr_writer :key

    end
end
