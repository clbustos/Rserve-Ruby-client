module Rserve

  module With2DNames
    attr_reader :row_names, :column_names

    def names=(names)
      raise ArgumentError, "sizes must be of size 2" unless (names.size == 2)
      if self.is_a? Array
        raise ArgumentError, "mismatch between the size of row labels and the actual number of elements" if (names[0] and ((self.count % names[0].size) != 0))
        raise ArgumentError, "mismatch between the size of column labels and the actual number of elements" if (names[1] and ((self.count % names[1].size) != 0))
        raise ArgumentError, "mismatch between the provided sizes and the actual number of elements" if (names[0] and names[1] and ((names[0].size * names[1].size) != self.count))
      elsif self.is_a? Matrix
        raise ArgumentError, "mismatch between the size of row labels and the actual number of rows" if (names[0] and (names[0].size != self.row_size))
        raise ArgumentError, "mismatch between the size of column labels and the actual number of rows" if (names[1] and (names[1].size != self.column_size))
      else
        raise ArgumentError, "unsupported type for With2DNames"
      end
      @row_names = names[0]
      @column_names = names[1]
    end

    def by_name(row_name, column_name)
      return nil unless @row_names and @column_names
      i = @row_names.index(row_name)
      j = @column_names.index(column_name)
      return nil unless i and j
      if self.is_a? Array
        at_2d(i, j)
      elsif self.is_a? Matrix
        self[i, j]
      else
        raise ArgumentError, "unsupported type for With2DNames"
      end
    end

    def row_by_name(name)
      return nil unless @row_names
      i = @row_names.index(name)
      return nil unless i
      result = row(i).to_a
      if @column_names
        result.extend WithNames
        result.names = @column_names
      end
      result
    end

    def column_by_name(name)
      return nil unless @column_names
      j = @column_names.index(name)
      return nil unless j
      result = column(j).to_a
      if @row_names
        result.extend WithNames
        result.names = @row_names
      end
      result
    end

    def named_2d?
      !(@row_names.nil? or @column_names.nil?)
    end

  end


end