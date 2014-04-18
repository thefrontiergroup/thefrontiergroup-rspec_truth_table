require_relative './truth_table_definition'

module RspecTruthTable
  class TruthTable
    attr_reader :rows

    def initialize(context)
      self.context = context
      self.rows = []
    end

    def setup(&block)
      self.setup_block = block
      self.column_names = block.parameters.map(&:last)
    end

    def t
      define(true)
    end

    def f
      define(false)
    end

    def x
      define(:any)
    end

    alias :any :x

    def _run
      rows = expand

      # create closure so we can access inside of instance_exec
      _setup_block = setup_block
      _column_names = column_names

      rows.each do |row|
        context.instance_exec do

          # transform in to array of true / false
          row = row.map { |column| column.key }
          args = row[0...-1]

          components = _column_names.zip(args).map do |key, value|
            "#{key}: #{value}"
          end

          message = components.join(', ')

          context(message) do
            instance_exec(*args, &_setup_block)
            it "returns #{row.last}" do
              should eq row.last
            end
          end
        end
      end
    end

    private

    def hash_row_columns(columns)
      columns[0...-1].map do |x|
        case x.key
        when true
          't'
        when false
          'f'
        when :any
          'x'
        end
      end.join().to_sym
    end

    def expand
      # This table represents all permutations possible
      table = [TruthTableDefinition.new(true), TruthTableDefinition.new(false)].repeated_permutation(column_names.length())

      # Convert to array of TruthTableDefinition arrays
      rows = self.rows.map(&:columns)

      table.map do |table_row|
        definitions = rows.select do |definition_row|
          result = true
          table_row.length.times do |index|
            result &&= table_row[index] == definition_row[index]
          end
          result
        end

        if definitions.count == 0
          raise "Row undefined: #{table_row.inspect}"
        else
          table_row << definitions.first.last
        end
        table_row
      end
    end

    def expand_row(columns, set)
      any_index = columns.find_index { |d| d.key == :any }
      if any_index
        r1 = columns.dup
        r2 = columns.dup
        r1[any_index] = TruthTableDefinition.new(true)
        r2[any_index] = TruthTableDefinition.new(false)

        # If these are in the set, then we either have all ready, or will expand the row
        # without recursion
        result = []

        r1h = hash_row_columns(r1)
        r2h = hash_row_columns(r2)

        unless set.include?(r1h)
          puts "Auto - #{r1h} - #{r1.last}"
          set << r1h
          result += expand_row(r1, set)
        end

        unless set.include?(r2h)
          puts "Auto - #{r2h} - #{r2.last}"
          set << r2h
          result += expand_row(r2, set)
        end

        return result
      end
      [columns]
    end

    def define(sym)
      val = TruthTableDefinition.new(sym, rows)
      rows << val
      val
    end

    attr_accessor :context, :column_names, :setup_block
    attr_writer :rows
  end
end
