module Rserve

  module With2DNames
    attr_reader :row_names, :column_names

    def names=(names)
      raise ArgumentError, "sizes must be of size 2" unless (names.size == 2)
      if self.is_a? Array
        raise ArgumentError, "mismatch between provided size info and actual number of elements" unless (names[0].size * names[1].size) == self.count
      elsif self.is_a? Matrix
        raise ArgumentError, "mismatch between the provided size info and actual number of elements" unless ((names[0].size == self.row_size) and (names[1].size == self.column_size))
      else
        raise ArgumentError, "unsupported type for With2DNames"
      end
      @row_names = names[0]
      @column_names = names[1]
    end

    def by_name(row_name, column_name)
      i = @row_names.index(row_name)
      j = @column_names.index(column_name)
      return nil unless i and j
      if self.is_a? Array
        at2d(i, j)
      elsif self.is_a? Matrix
        self[i, j]
      else
        raise ArgumentError, "unsupported type for With2DNames"
      end
    end

    def row_by_name(name)
      i = @row_names.index(name)
      return nil unless i
      row(i)
    end

    def column_by_name(name)
      j = @column_names.index(name)
      return nil unless j
      column(j)
    end

    def named_2d?
      @row_names and @column_names
    end

  end


end